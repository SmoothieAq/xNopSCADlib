
include <../xNopSCADlib/core.scad>

include <../xVitamins/xnuts.scad>


n = axnut(M3_nut,material=MaterialBlackSteel);

xnut(n,depth=0.7,twist=30);
difference() {
	union() {
		translate([0, 0, -11]) rotate([15,0,0]) cube(18, center = true);
		xnut_plate(n,depth=0.7);
	}
	xnut_hole(n,depth=0.7,twist=30);
}