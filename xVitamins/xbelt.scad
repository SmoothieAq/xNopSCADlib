
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/belt.scad>
use <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/pulleys.scad>

//
// We model the belt path at the pitch radius of the pulleys and the pitch line of the belt to get an accurate length.
// The belt is then drawn by offseting each side from the pitch line.
//
module xbelt(type, points, open = false, twist = undef, auto_twist = true, start_twist = false, gap = 0, gap_pos = undef, belt_colour = grey(20), tooth_colour = grey(50)) { //! Draw a belt path given a set of points and pitch radii where the pulleys are. Closed loop unless a gap is specified
	width = belt_width(type);
	pitch = belt_pitch(type);
	thickness = belt_thickness(type);

	info = _belt_points_info(type, points, open, twist, auto_twist, start_twist);
	dotwist = info[0];
	twisted = info[1];
	pointsx = info[2];
	tangents = info[3];
	arcs = info[4];
	length = 0;//ceil(rounded_polygon_length(points, tangents) / pitch) * pitch;

	part = str(type[0],pitch);
	vitamin(str("xbelt(", no_point(part), "x", width, ", ", points, "): Belt ", part," x ", width, "mm x ", length, "mm"));

	len = len(points);

	th = belt_tooth_height(type);
	ph = belt_pitch_height(type);
	module beltp() translate([ph-th,-width/2]) square([th,width]);
	module beltb() translate([ph-thickness,0-width/2]) square([thickness-th,width]);
	echo(info=info);

	difference() {
		for (i = [0:len-(open?2:1)]) {
			p1 = tangents[i].x;
			p2 = tangents[i].y;
			a = a2(p2-p1);
			l = norm(p2-p1);
			translate(p1) rotate([-90, 0, a-90]) {
				twist = dotwist[i] ? 180 : 0;
				mirrored = twisted[i] ? 1 : 0;
				color(tooth_colour) linear_extrude(l, twist = twist) mirror([mirrored, 0, 0]) beltp();
				color(belt_colour) linear_extrude(l, twist = twist) mirror([mirrored, 0, 0]) beltb();
			}
		}
		if(gap)
			linear_extrude(width, center = true)
				translate([gap_pos.x, gap_pos.y])
					rotate(is_undef(gap_pos.z) ? 0 : gap_pos.z)
						translate([0, ph - thickness / 2])
							square(is_list(gap) ? [gap.x, gap.y + thickness + eps] : [gap, thickness + eps], center = true);
	}
	for (i = [(open?1:0):len-(open?2:1)]) {
		p = pointsx[i];
		arc = arcs[i];
		*#translate([p.x,p.y,0]) cylinder(width,r=abs(p.z));
		translate([p.x,p.y,0]) rotate([0,0,arc.y]) {
			mirrored = !xor(twisted[i],p.z < 0) ? 1 : 0;
			color(tooth_colour) rotate_extrude(angle=arc.x) translate([abs(p.z),0,0]) mirror([mirrored,0,0]) beltp();
			color(belt_colour) rotate_extrude(angle=arc.x) translate([abs(p.z),0,0]) mirror([mirrored,0,0]) beltb();
		}
	}

}

function _belt_points_info(type, points, open, twist, auto_twist, start_twist) = let(
	len = len(points),
	vec2 = function(p) [p.x,p.y],
	isleft = function(i) let(
					p = vec2(points[i]),
					p0 = vec2(points[(i - 1 + len) % len]),
					p1 = vec2(points[(i + 1) % len])
				) cross(p-p0,p1-p) > 0,
	dotwist = function(i,istwisted) let( in = (i + 1) % len )
				is_list(twist) ? twist[i] :
				!is_undef(twist) ? i == twist :
				open && is_list(points[in].z) && auto_twist ? !pulley_teeth(points[in].z) && !xor(isleft(in),istwisted) :
				false,
	twisted = [ for (
			i = 0,
			istwisted = start_twist,
			twist = dotwist(i,istwisted),
			nexttwisted = xor(twist,istwisted);
		i < len;
			i = i + 1,
			istwisted = nexttwisted,
			twist = dotwist(i,istwisted),
			nexttwisted = xor(twist,istwisted)
	) [twist,istwisted] ],
	pointsx = [ for (i = [0:len-1]) !is_list(points[i].z) ? points[i] : [points[i].x, points[i].y, let(
			isleft = isleft(i),
			norm = !xor(isleft, twisted[i].y),
			thickness = belt_thickness(type),
			ph = belt_pitch_height(type),
			r = pulley_teeth(points[i].z)
				? let( ppr = pulley_pr(points[i].z)) norm ? ppr : ppr + thickness - ph
				: let (pir = pulley_ir(points[i].z)) norm ? pir + ph : pir + thickness - ph
		) isleft ? -r : r ] ],
	tangents = rounded_polygon_tangents_v2(pointsx),
	arcs = rounded_polygon_arcs(pointsx, tangents)
) [ [ for (t = twisted) t.x ], [ for (t = twisted) t.y ], pointsx, tangents, arcs];


function belt_length(points, gap = 0) = rounded_polygon_length(points, rounded_polygon_tangents(points)) - gap; //! Compute belt length given path and optional gap

function rounded_polygon_arcs(points, tangents) = //! Compute the arcs at the points, for each point [angle,rotate_angle,lenght]
	let(
		len = len(points)
	) [ for (i = [0: len-1])
		let(
			p1 = tangents[(i - 1 + len) % len].y,
			p2 = tangents[i].x,
			p = points[i],
			v1 = p1 - p,
			v2 = p2 - p,
			r = abs(p.z),
			a = r == 0 ? 0 : let( aa = acos((v1 * v2) / sqr(r)) ) cross(v1, v2)*sign(p.z) <= 0 ? aa : 360 - aa,
			l = PI * a * r / 180,
			v0 = [r, 0],
			v = r == 0 ? 0 : (abs(v0.x-v2.x) < 0.001 && abs(v0.y-v2.y) < 0.001) ? 0 : let (
				vv = let( aa = acos((v0 * v2) / sqr(r)) ) cross(v0, v2)*sign(p.z) <= 0 ? aa : 360 - aa
				) p.z > 0 ? 360 - vv : vv - a
		) [a, v, l]
	];

function rounded_polygon_tangents_v2(points) = //! Compute the straight sections, for each section [start_point, end_point, length]
	let(len = len(points))
		[ for(i = [0 : len - 1])
			let(ends = circle_tangent(points[i], points[(i + 1) % len]))
			[ends.x,ends.y,norm(ends.x-ends.y)] ];


