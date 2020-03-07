
include <../xNopSCADlib/core.scad>

include <../xxVitamins/xxscrews.scad>
include <../xVitamins/xextrusions.scad>
include <../xVitamins/xtslot_nuts.scad>
include <../xxVitamins/xxDefaults.scad>

$bom=0;
$debug=3;

part1thick = 15;
part2thick = 7;

module part1() cube([40,40,part1thick]);

module part2(t=part2thick) cube([40,40,t]);

screwPart = axscrew(M3_cap_screw,material=MaterialBlackSteel);



//partScrews = [
//	axxscrew(screwPart,l=30,t=[20,15,part1thick],thick=part1thick+part2thick),
//	axxscrew_setLeng(screwPart,t=[20,30,part1thick],thick=part1thick+part2thick),
//	axxscrew_setLengAdjustDepth(screwPart,t=[20,45,part1thick],thick=part1thick+part2thick)
//];
partScrews1 = [
	axscrew(M3_cap_screw,material=MaterialBlackSteel),
	axscrew(M3_cs_cap_screw,material=MaterialBlackSteel),
	axscrew(M3_dome_screw,material=MaterialBlackSteel),
	axscrew(M3_hex_screw,material=MaterialBlackSteel)
];

//partScrews1nut = [ for (i = [0:len(partScrews1)-1]) each [
//	axxscrew(partScrews1[i],l=30,t=[5 + i * 10, 10, part1thick], thick=part1thick+part2thick, washer=true, nut_washer=true),
//	axxscrew_setLeng(partScrews1[i],t=[5 + i * 10, 20, part1thick], thick=part1thick+part2thick, washer=true, nut_washer=true),
//	axxscrew_setLengAdjustDepth(partScrews1[i],t=[5 + i * 10, 30, part1thick], thick=part1thick+part2thick, washer=true, nut_washer=true)
//] ];
//
//xtest(partScrews1nut,[0,128/256,128/256])
//	{part1(); translate([0,0,-part2thick]) part2(part2thick);}

//partScrews1insert = [ for (i = [0:len(partScrews1)-1]) each [
//	axxscrew(partScrews1[i],l=30,t=[5 + i * 10, 10, part1thick], thick=part1thick, insert=true, washer=true),
//	axxscrew_setLeng(partScrews1[i],t=[5 + i * 10, 20, part1thick], thick=part1thick, insert=true, washer=true),
//	axxscrew_setLengAdjustDepth(partScrews1[i],t=[5 + i * 10, 30, part1thick], thick=part1thick, insert=true, washer=true)
//] ];
//
//translate([0,60,0])
//	xtest(partScrews1insert,[0,128/256,128/256])
//		{part1(); translate([0,0,-part2thick]) part2(part2thick);}

//extr = axextrusion(E2020,l = 50);
//partScrews1tslot = [ for (i = [0:len(partScrews1)-1]) [
//	axxscrew(partScrews1[i],l=30,t=[10, 10, part1thick], thick=part1thick, extrusion=extr, washer=true),
//	axxscrew_setLeng(partScrews1[i],t=[10, 20, part1thick], thick=part1thick, extrusion=extr, washer=true),
//	axxscrew_setLengAdjustDepth(partScrews1[i],t=[10, 30, part1thick], thick=part1thick, extrusion=extr, washer=true)
//] ];
//
//translate([0,120,0])
//	for (i = [0:len(partScrews1tslot)-1])
//		translate([i*120,0,0])
//			xtest(partScrews1tslot[i],[0,128/256,128/256],width=20)
//				{cube([20,40,part1thick]); translate([10,45,-10]) rotate([90,0,0]) xextrusion(extr);}

extr2 = axextrusion(E2020,l = 24);
translate([0,180,0])
for (i = [0:len(partScrews1)-1]) {
	s1 = axxscrew_setLengAdjustThick(partScrews1[i], thick = part1thick+part2thick, washer=true, nut_washer=true);
	translate([i*120,0,0])
		xtest([axxscrew(s1, t = [10, 10, xxscrew_thick(s1)-part2thick])],[0,128/256,128/256],width=20)
			{cube([20,20,xxscrew_thick(s1)-part2thick]); translate([0,0,-part2thick]) cube([20,20,part2thick]);}
	s2 = axxscrew_setLengAdjustThick(partScrews1[i], thick = part1thick, insert=true, washer=true);
	translate([i*120,30,0])
		xtest([axxscrew(s2, t = [10, 10, xxscrew_thick(s2)])],[0,128/256,128/256],width=20)
			{cube([20,20,xxscrew_thick(s2)]); translate([0,0,-part2thick]) cube([20,20,part2thick]);}
	s3 = axxscrew_setLengAdjustThick(partScrews1[i], thick = part1thick, extrusion= extr2, washer=true);
	translate([i*120,60,0])
		xtest([axxscrew(s3, t = [10, 10, xxscrew_thick(s3)])],[0,128/256,128/256],width=20)
			{cube([20,20,xxscrew_thick(s3)]); translate([10,22,-10]) rotate([90,0,0]) xextrusion(extr2);}
}



module test(screws,color,noscrews,flip) {
	xxpart1(screws,concat(color,[!flip?0.6:0.3]),noscrews)
		children(0);
	xxpart2(screws,concat(color,[!flip?0.3:0.6]),noscrews)
		children(1);
}

module xtest(screws,color,width=40) {
	spacing = width + 10;
	test(screws,color,true,false) {children(0); children(1);}
	translate([spacing*1-5+width,0,0]) rotate([0,180,0]) test(screws,color,true,true) {children(0); children(1);}
	translate([spacing*2,0,0]) test(screws,color,false,false) {children(0); children(1);}
	translate([spacing*3-5+width,0,0]) rotate([0,180,0]) test(screws,color,false,true) {children(0); children(1);}
}

