include <../xNopSCADlib/core.scad>
use <../xUtil/xUtil.scad>
use <NopSCADlib/vitamins/screw.scad>
use <NopSCADlib/vitamins/washer.scad>
use <xnut.scad>
use <xwasher.scad>

function xscrew_material(type) = nnv(type[17], MaterialSteel);
function xscrew_length(type) = type[18];
function xscrew_hob_point(type) = nnv(type[19], 0);
function xscrew_nut(type) = axnut(screw_nut(type), material = xscrew_material(type));

function xscrew_names() = ["material","lenght","hob_point","nut"];
function xscrew_descr(type) = descr(type, xscrew_names(), 17);

function axscrew(screw, l, material, hob_point) = axcreate(screw, [material, l, hob_point], 17);

module xscrew(screw, l, depth, washer, twist, horizontal) {
	if ($debug > 1) echo("xscrew", xscrew_descr(screw),l, depth, washer, twist, horizontal);
	assert(is_list(screw) && is_string(screw[0]), "The screw argument does not seem to be a xscrew nor a screw");
	xl = nnv(l, xscrew_length(screw));
	assert(xl > 0, "you must specify lenght for screw");
	hob_point = xscrew_hob_point(screw);
	nylon = xscrew_material(screw) == MaterialNylon;
	xtwist = nnv(twist, horizontal ? 30 : 0);

	colorize(material_color(xscrew_material(screw)))
		translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) + (washer ? xwasher_thickness(washer != true ? washer : screw_washer(screw)) : 0 + 0.001)])
			rotate([0, 0, xtwist])
				screw(screw, xl, hob_point, nylon);
}

module xscrew_hole(screw, l, depth, spacing, washer, horizontal, twist) {
	if ($debug > 2) echo("xscrew_hole", xscrew_descr(screw), l, depth, spacing, washer, horizontal, twist);
	assert(is_list(screw) && is_string(screw[0]), "The screw argument does not seem to be a xscrew nor a screw");
	xl = nnv(l, xscrew_length(screw));
	assert(xl > 0, "you must specify lenght for screw");
	xspacing = nnv(spacing, min(10, xl * .75));
	xheadr = (washer ? washer_diameter(screw_washer(screw)) / 2 : screw_head_radius(screw)) * 1.1;
	xtwist = nnv(twist, horizontal ? 30 : 0);

	if (screw_head_type(screw) == hs_cs_cap || screw_head_type(screw) == hs_cs)
		translate([0, 0, - nnv(depth, 0) + 0.001 - screw_head_radius(screw)])
			cylinder(h = screw_head_radius(screw) * 1.05, r1 = 0, r2 = screw_head_radius(screw) * 1.05);
	else if (screw_head_type(screw) == hs_hex)
		rotate([0, 0, xtwist])
			translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) + 0.001])
				linear_extrude(height = screw_head_height(screw) + xspacing)
					circle(screw_head_radius(screw) * 1.05, $fn = 6);
	else
		translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) + 0.001])
			xhole(xheadr, screw_head_height(screw) + xspacing, horizontal);

	translate([0, 0, nnv(depth, 0) * screw_head_height(screw) + 0.001])
		xhole(xheadr, xspacing, horizontal);
	translate([0, 0, - xl - 0.1 - nnv(depth, 0) * screw_head_height(screw)])
		rotate(is_num(horizontal) ? [0,0,horizontal] : [0,0,0])
			xhole(screw_clearance_radius(screw), xl + 0.2, horizontal);
}

module xscrew_plate(screw, depth, plate, washer) {
	if ($debug > 2) echo("xscrew_plate", xscrew_descr(screw), depth, plate, washer);
	assert(is_list(screw) && is_string(screw[0]), "The screw argument does not seem to be a xscrew nor a screw");
	xplate = nnv(plate, screw_head_height(screw) * 2);
	xheadr = (washer ? washer_diameter(screw_washer(screw)) / 2 * 1.05 : screw_head_radius(screw) * 1.15);

	translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) - xplate])
		cylinder(r = xheadr, h = xplate);
}


