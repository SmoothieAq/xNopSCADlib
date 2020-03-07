
include <../xNopSCADlib/core.scad>

include <../xVitamins/xscrews.scad>

s = axscrew(axscrew(M3_cap_screw,material=MaterialBlackSteel),l=33);

xscrew(s,depth=0.5);
difference() {
	union() {
		translate([0, 0, -11]) rotate([15,0,0]) cube(18, center = true);
		xscrew_plate(s,depth=0.5);
	}
	xscrew_hole(s,depth=0.5,horizontal=true);
}

s2 = axscrew(axscrew(M3_cap_screw,material=MaterialBlackSteel),l=33);

translate([25,0,0]) {
	xscrew(s2, depth = 0.5);
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s2, depth = 0.5);
		}
		xscrew_hole(s2, depth = 0.5, horizontal = true);
	}
}
translate([25,25,0]) {
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s2, depth = 0.5);
		}
		xscrew_hole(s2, depth = 0.5, horizontal = true);
	}
}

s3 = axscrew(axscrew(M3_cs_cap_screw,material=MaterialBlackSteel),l=33);

translate([50,0,0]) {
	xscrew(s3);
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s3);
		}
		xscrew_hole(s3, horizontal = true);
	}
}
translate([50,25,0]) {
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s3);
		}
		xscrew_hole(s3, horizontal = true);
	}
}


s4 = axscrew(axscrew(M3_hex_screw,material=MaterialBlackSteel),l=33);

translate([75,0,0]) {
	xscrew(s4, depth = 0.5, horizontal = true);
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s4, depth = 0.5);
		}
		xscrew_hole(s4, horizontal = true, depth = 0.5);
	}
}
translate([75,25,0]) {
	difference() {
		union() {
			translate([0, 0, -9]) cube(18, center = true);
			xscrew_plate(s4, depth = 0.5);
		}
		xscrew_hole(s4, horizontal = true, depth = 0.5);
	}
}
