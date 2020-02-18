include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/screw.scad>
use <xnut.scad>

function xscrew_material(type) = nnv(type[17], MaterialSteel);
function xscrew_length(type) = type[18];
function xscrew_hob_point(type) = nnv(type[19], 0);
function xscrew_nut(type) = echo("xscrew_nut(type)",type)axnut(screw_nut(type), material = xscrew_material(type));

function xscrew_def(type) = str(type[0],", material=",type[17],", length=",type[18],", hob_point=",type[19]);

function axscrew(screw, l, material, hob_point) = axcreate(screw, [material, l, hob_point], 17);

module xscrew(screw, l, depth, washer) { echo("xscrew",xscrew_def(screw));
	xl = nnv(l, xscrew_length(screw));
	assert(xl > 0, "you must specify lenght for screw");
	hob_point = xscrew_hob_point(screw);
	nylon = xscrew_material(screw) == MaterialNylon;

	echo("screw",screw[0], xl, hob_point, nylon,l,xscrew_length(screw));
	colorize(material_color(xscrew_material(screw)))
		translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) + (washer ? xwasher_thickness(washer != true ? washer : screw_washer(screw)) : 0)])
			screw(screw, xl, hob_point, nylon);
}

module xscrew_hole(screw, l, depth, spacing, washer, horizontal) {
	xl = nnv(l, xscrew_length(screw));
	assert(xl > 0, "you must specify lenght for screw");
	xspacing = nnv(spacing, min(10, xl * .75));
	xheadr = (washer ? washer_diameter(screw_washer(screw)) : screw_head_radius(screw)) * 1.1;

	echo("xscrew_hole",xheadr,screw_radius(screw));
	translate([0, 0, - nnv(depth, 0) * screw_head_height(screw)])
		 xhole(xheadr, screw_head_height(screw) + xspacing, horizontal);
	translate([0, 0, - xl - 0.1])
		xhole(screw_radius(screw), xl + 0.2, horizontal);
}

module xscrew_plate(screw, depth, plate, washer) {
	xplate = nnv(plate, screw_head_height(screw) * 2);
	xheadr = (washer ? washer_diameter(screw_washer(screw)) * 1.05 : screw_head_radius(screw) * 1.15);

	translate([0, 0, - nnv(depth, 0) * screw_head_height(screw) - xplate])
		cylinder(r = xheadr, h = xplate);
}


