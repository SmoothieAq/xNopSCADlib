
include <../xNopSCADlib/core.scad>

include <../xxVitamins/xxscrews.scad>
include <../xxVitamins/xxDefaults.scad>

$_bom=3;

part1thick = 16;
part2thick = 8;

module part1() cube([40,60,part1thick]);

module part2() cube([40,60,part2thick]);

screwPart = axscrew(M3_cap_screw,material=MaterialBlackSteel);
screw = axxscrew(screwPart,l=30,t=[20,30,part1thick],thick=part1thick+part2thick);

//xxpart1([screw],[0,128/256,128/256,0.6])
//	part1();
//xxpart2([screw],[0,128/256,128/256,0.2])
//	translate([0, 0, -8]) part2();

module test(screws,color,noscrews,flip) {
	xxpart1(screws,concat(color,[!flip?0.6:0.3]),noscrews)
		children(0);
	xxpart2(screws,concat(color,[!flip?0.3:0.6]),noscrews)
		children(1);
}

module xtest(screws,color,spacing=55) {
	test(screws,color,true,false) {children(0); children(1);}
	translate([spacing*1-5,0,0]) rotate([180,0,0]) test(screws,color,true,true) {children(0); children(1);}
	translate([spacing*2,0,0]) test(screws,color,false,false) {children(0); children(1);}
	translate([spacing*3-5,0,0]) rotate([180,0,0]) test(screws,color,false,true) {children(0); children(1);}
}

xtest([screw],[0,128/256,128/256])
	{part1(); translate([0,0,-8]) part2();}