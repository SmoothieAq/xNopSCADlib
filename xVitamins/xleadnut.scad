
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/leadnut.scad>
use <NopSCADlib/vitamins/spring.scad>

function xleadnut_material(type)	= nnv(type[14], MaterialSteel);
function xleadnut_color(type)		= type[15];
function xleadnut_antib_od(type)	= type[16];
function xleadnut_antib_h(type)		= type[17];
function xleadnut_antib_spring(type)= type[18];

function axleadnut(xleadnut, material, col, antib) = antib ? axcreate(xleadnut, [material, col, antib[0], antib[1], antib[2]], 14) : axcreate(xleadnut, [material, col]);

module xleadnut(xleadnut) {
	color(material_color(xleadnut_material(xleadnut),xleadnut_color(xleadnut))) {
		leadnut(xleadnut);
		if (xleadnut_antib_od(xleadnut)) {
			translate([0, 0, - leadnut_shank(xleadnut)])
				difference() {
					cylinder(h = xleadnut_antib_h(xleadnut), d = xleadnut_antib_od(xleadnut));
					translate([0, 0, - 0.1])
						cylinder(h = xleadnut_antib_h(xleadnut) + 0.2, d = leadnut_bore(xleadnut));
				}
		}
	}
	if (xleadnut_antib_od(xleadnut)) {
		l = leadnut_shank(xleadnut) - xleadnut_antib_h(xleadnut);
		spring = nnv(xleadnut_antib_spring(xleadnut),["leadnut spring",leadnut_od(xleadnut)+1.65,0.8,l*2,8,1,false,undef,"silver"]);
		translate([0,0,-l])
			comp_spring(spring,l=l);
	}
}


