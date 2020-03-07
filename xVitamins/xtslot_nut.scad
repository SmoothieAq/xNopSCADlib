
include <../xNopSCADlib/core.scad>

use <../xNopSCADlib/vitamins/tslot_nut.scad>

function xtslot_nut_material(type)	= nnv(type[10], MaterialSteel);

function axtslot_nut(tslot_nut, material) = axcreate(tslot_nut, [material], 10);

module xtslot_nut(tslot_nut) {
	translate([0, 0, tslot_nut_height(tslot_nut)])
		rotate([180, 0, 0])
			tslot_nut(tslot_nut, xtslot_nut_material(tslot_nut));
}

