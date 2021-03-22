
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/belt.scad>
use <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/pulleys.scad>

//
// We model the belt path at the pitch radius of the pulleys and the pitch line of the belt to get an accurate length.
// The belt is then drawn by offseting each side from the pitch line.
//
module xbelt(type, points, open = false, twist = undef, auto_twist = false, start_twist = false, gap = 0, gap_pos = undef, belt_colour = grey(20), tooth_colour = grey(50)) { //! Draw a belt path given a set of points and pitch radii where the pulleys are. Closed loop unless a gap is specified
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
		translate([p.x,p.y,0]) rotate([0,0,arc.y]) {
			mirrored = !xor(twisted[i],p.z < 0) ? 1 : 0; echo(i,mirrored,p.z);
			color(tooth_colour) rotate_extrude(angle=arc.x) translate([abs(p.z),0,0]) mirror([mirrored,0,0]) beltp();
			color(belt_colour) rotate_extrude(angle=arc.x) translate([abs(p.z),0,0]) mirror([mirrored,0,0]) beltb();
		}
	}

}

function _belt_points_info(type, points, open, twist, auto_twist, start_twist) = //! Helper function that calulates [twist, istwisted, points, tangents, arcs]
	let(
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
		pointsx = mapi(points, function(i, p) !is_list(p.z) ? p : [p.x, p.y, let( // if p.z is not a list it is just r, otherwise it is taken to be a pulley and we calculate r
				isleft = isleft(i),
				r = belt_pulley_pr(type, p.z, twisted=!xor(pulley_teeth(p.z),xor(isleft, twisted[i].y)))
//				norm = !xor(isleft, twisted[i].y),
//				thickness = belt_thickness(type),
//				ph = belt_pitch_height(type),
//				r = pulley_teeth(p.z)
//					? let( ppr = pulley_pr(p.z)) norm ? ppr : ppr + thickness - ph
//					: let (pir = pulley_ir(p.z)) norm ? pir + ph : pir + thickness - ph
			) isleft ? -r : r ] ),
		tangents = rounded_polygon_tangents_v2(pointsx),
		arcs = rounded_polygon_arcs(pointsx, tangents)
	) [ [ for (t = twisted) t.x ], [ for (t = twisted) t.y ], pointsx, tangents, arcs];

function belt_pulley_pr(type, pulley, twisted=false) = //! Pitch radius. Default it expects the belt tooth to be against a toothed pulley an the backside to be against a smooth pulley (an idler). If `twisted` is true, the the belt is the other way around.
	let(
		thickness = belt_thickness(type),
		ph = belt_pitch_height(type)
	) pulley_teeth(pulley)
		? pulley_pr(pulley) + (twisted ? thickness - ph : 0 )
		: pulley_ir(pulley) + (twisted ? ph : thickness - ph );

function belt_length(type, points, open = false, gap = 0) = _belt_length(_belt_points_info(type, points, open), open, gap); //! Compute belt length given path and optional gap

function _belt_length(info, open, gap) = let(
		len = len(info[0]),
		d = open ? 1 : 0,
		tangents = slice(info[3], [0:len - 1 - d]) ,
		arcs = slice(info[4], [d:len - 1 - d]),
		beltl = echo(concat(tangents, arcs)) echo(map( concat(tangents, arcs), function(e) e.z ))sumv( map( concat(tangents, arcs), function(e) e.z ) ),
		gapl = is_list(gap) ? gap.x : is_undef(gap) ? 0 : gap
	) beltl - gapl;

function rounded_polygon_arcs(points, tangents) = //! Compute the arcs at the points, for each point [angle,rotate_angle,length]
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
			a = let( aa = acos((v1 * v2) / sqr(r)) ) cross(v1, v2)*sign(p.z) <= 0 ? aa : 360 - aa,
			l = PI * a * r / 180,
			v0 = [r, 0],
			v = norm(v0-v2) < 0.001 ? 0 : let (
					vv = let( aa = acos((v0 * v2) / sqr(r)) ) cross(v0, v2)*sign(p.z) <= 0 ? aa : 360 - aa
				) p.z > 0 ? 360 - vv : vv - a
		) [a, v, l]
	];

function rounded_polygon_tangents_v2(points) = //! Compute the straight sections, for each section [start_point, end_point, length]
	let(len = len(points))
		[ for(i = [0 : len - 1])
			let(ends = circle_tangent(points[i], points[(i + 1) % len]))
			[ends.x,ends.y,norm(ends.x-ends.y)] ];


function slice(v, range) = [ for (i = range) v[i] ]; //! slice a section of a vector v, takes elements from v with index in the range
function map(v, func) = [ for (e = v) func(e) ]; //! make a new vector where the func function argument is applied to each element of the vector v
function mapi(v, func) = [ for (i = [0:len(v)-1]) func(i,v[i]) ]; //! make a new vector where the func function argument is applied to each element of the vector v. The func will get the index number as first argument, and the element as second argument.
function reduce(v, func, unity) = let ( r = function(i,val) i == len(v) ? val : r(i + 1, func(val, v[i])) ) r(0, unity); //! reduce a vector v to a single entity by applying the func function recursivly to the reduced value so far and the next element, starting with unity as the inital reduced value
function sumv(v) = reduce(v, function(a, b) a + b, 0); //! sum a vector of values that can be added with "+"