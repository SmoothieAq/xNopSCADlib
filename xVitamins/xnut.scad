
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/nut.scad>

function xnut_material(type)	= nnv(type[10], MaterialSteel);
function xnut_nyloc(type)		= nnv(type[11], false);
function xnut_thickness(type)	= nut_thickness(type, xnut_nyloc(type));

function axnut(nut, material, nyloc) = axcreate(nut, [material, nyloc], 10);

module xnut(nut, depth, washer, twist, horizontal) {
	xtwist = nnv(twist, horizontal ? 30 : 0);

	colorize(material_color(xnut_material(nut)))
		translate([0, 0, -nnv(depth, 0) * xnut_thickness(nut) + (washer ? xwasher_thickness(washer != true ? washer : nut_washer(nut)) : 0)])
			rotate([0, 0, xtwist])
				nut(nut, xnut_nyloc(nut), xnut_material(nut) == MaterialBrass, xnut_material(nut) == MaterialNylon);
}

module xnut_hole(nut, depth, spacing, washer, twist, horizontal) {
	xtwist = nnv(twist, horizontal ? 30 : 0);
	thick = xnut_thickness(nut);
	xspacing = nnv(spacing, thick * 1.2);

	translate([0, 0, -nnv(depth, 0) * thick])
		if (washer)
			xhole(washer_diameter(washer != true ? washer : nut_washer(nut)), thick, horizontal);
		else
			rotate([0, 0, xtwist])
				linear_extrude(height = thick)
					circle(nut_radius(nut) * 1.05, $fn = 6);
}

module xnut_plate(nut, depth, plate, washer) {
	thick = xnut_thickness(nut);
	xplate = nnv(plate, thick * 2);
	xheadr = (washer ? washer_diameter(washer != true ? washer : nut_washer(nut)) * 1.05 : nut_radius(nut) * 1.15);

	translate([0, 0, -nnv(depth, 0) * thick - xplate])
		cylinder(r = xheadr, h = xplate);
}

