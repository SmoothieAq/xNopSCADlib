
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
