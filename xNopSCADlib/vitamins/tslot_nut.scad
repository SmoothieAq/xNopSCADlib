
//
//! T-slot nuts for extrusions.
//
include <../core.scad>
use <NopSCADlib/utils/fillet.scad>

function tslot_nut_width(type)		= type[1];
function tslot_nut_height(type)		= type[2];
function tslot_nut_length(type)		= type[3];
function tslot_nut_tab_with(type)	= type[4];
function tslot_nut_tab_height(type)	= type[5];
function tslot_nut_screw_diameter(type)	= type[6];
function tslot_nut_drop_in(type)	= type[7];
function tslot_nut_extrusion_type(type) = type[8];

module tslot_nut(type, material = MaterialSteel) { //! Draw a T-slot nut of the specified type
	h = tslot_nut_height(type);
	ht = tslot_nut_tab_height(type);
	hb = h - ht;
	l = tslot_nut_length(type);
	wb = tslot_nut_width(type);
	wt = tslot_nut_tab_with(type);
	r = tslot_nut_length(type) / 2;

	module rounding(w, l, h, rot) {
		if (tslot_nut_drop_in(type)) {
			translate([w, l, - 0.01])
				rotate([0, 0, rot])
					fillet(r = r, h = h + 0.02, center = false);
		}
	}

	module side() {
		translate([0, 0, ht])
			difference() {
				cube([wt / 2, l, ht + 0.1]);
				rounding(wt / 2 + 0.01, -0.01, ht + 0.1, 90);
			}
		difference() {
			cube([wb / 2, l, hb]);
			rounding(wb / 2 + 0.01, l + 0.01, hb + 0.1, 180);
			translate([wb / 2, -1, -hb / 4 * 3 - 0.1])
				rotate([0, -45, 0])
					cube([h, l + 2, hb]);
		}
	}

	vitamin(str("tslot_nut(", type[0], ",", material, "): T-slot nut ", type[0], " ", material_name(material)));

	color(material_color(material))
		difference() {
			translate([0, - l / 2, 0]) {
				side();
				translate([0, l, 0]) rotate([0, 0, 180]) side();
			}
			translate([0, 0, -1])
				cylinder(r = tslot_nut_screw_diameter(type) / 2, h = h + 2 );
		}

}
