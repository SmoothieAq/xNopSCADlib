
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/nut.scad>
use <NopSCADlib/vitamins/washer.scad>
use <xwasher.scad>
use <dotSCAD/util/sub_str.scad>;

function xnut_material(type)	= nnv(type[11], MaterialSteel);
function xnut_nyloc(type)		= nnv(type[12], false);
function xnut_thickness(type)	= nut_thickness(type, xnut_nyloc(type));

function xnut_names() = ["material","nyloc"];
function xnut_descr(type) = descr(type, xnut_names(), 11);

function axnut(nut, material, nyloc) = axcreate(nut, [material, nyloc], 11);

module xnut(nut, depth, washer, twist, horizontal) { echo(n=nut[0],s=search("sliding_t",nut[0]));
	xtwist = nnv(twist, horizontal ? 30 : 0);

	colorize(material_color(xnut_material(nut)))
		explode(10)
			translate([0, 0, -nnv(depth, 0) * xnut_thickness(nut) + (washer ? xwasher_thickness(washer != true ? washer : nut_washer(nut)) : 0)])
				rotate([0, 0, xtwist])
					if (istnut(nut[0]))
						translate([0,0,nut[4]-nut[3]])
							sliding_t_nut(nut);
					else
						nut(nut, xnut_nyloc(nut), xnut_material(nut) == MaterialBrass, xnut_material(nut) == MaterialNylon);
}

function istnut(nam) = sub_str(nam,3,12) == "sliding_t" || sub_str(nam,3,9) == "hammer";

module xnut_hole(nut, depth, spacing, washer, twist, horizontal) {
	xtwist = nnv(twist, horizontal ? 30 : 0);
	xspacing = nnv(spacing, xnut_thickness(nut) * 1.2);
	thick = xnut_thickness(nut);

	translate([0, 0, -nnv(depth, 0) * thick])
		if (washer)
			xhole(washer_diameter(washer != true ? washer : nut_washer(nut)) / 2 * 1.05, thick + xspacing, horizontal);
		else
			rotate([0, 0, xtwist])
				linear_extrude(height = thick + xspacing)
					circle(nut_radius(nut) * 1.05, $fn = 6);
}

module xnut_plate(nut, depth, plate, washer) {
	thick = xnut_thickness(nut);
	xplate = nnv(plate, thick * 2);
	xheadr = (washer ? washer_diameter(washer != true ? washer : nut_washer(nut)) / 2 * 1.05 : nut_radius(nut));

	translate([0, 0, -nnv(depth, 0) * thick - xplate])
		cylinder(r = xheadr, h = xplate);
}

