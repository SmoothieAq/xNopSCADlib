
include <../xNopSCADlib/core.scad>

use <NopSCADlib/utils/core/rounded_rectangle.scad>
include <xextrusions.scad>
include <xscrews.scad>

module xextrusion_bracket3(cut=-1, assembly = true) {
	vitamin(str("xextrusion_bracket3(): Extrusion inner corner bracket ", "E30 M5"));

	thick = 6;
	exw = 30;
	size = [25, 7.8, 6.1];
	tabSizeY1 = 16;
	tabSizeY2 = 7.8;
	tabSizeZ = 4.1;
	tabz = size.z-tabSizeZ;
	holeRadius = M5_tap_radius;
	holeOffset = 2.5;

	rts = [[[180,0,0],[size.x/2+exw/2,0,-tabz]],[[180,0,90],[0,size.x/2+exw/2,-tabz]],[[0,90,0],[tabSizeZ-exw/2,0, -size.x/2-thick]],[[0, 90, 90], [0, tabz-exw/2, -size.x/2-thick]]];

	color(grey(20)) translate([0,0,thick]) {
		translate([0, 0, -thick/2])
			rounded_rectangle([exw, exw, thick], r = 3);
		for (i = [0:3])
			if (i != cut)
				translate(rts[i].y) rotate(rts[i].x)
					extrusionSlidingNut(size, tabSizeY1, tabSizeY2, tabSizeZ, holeRadius, holeOffset, false);
	}
}

//	size = extrusion_inner_corner_bracket_size(type);
//	armLength = size.x;
//	bottomTabOffset = 4;
//	topTabOffset = 10;
//	size = [armLength - bottomTabOffset, 7.9, 6];
//	sizeTop = [armLength - topTabOffset, 6, size.z];
//	tabSizeY1 = 10;
//	tabSizeY2 = 6;
//	tabSizeZ = 3.25;
//	holeRadius = M4_tap_radius;
//
//	extrusionSlidingNut(sizeBottom, tabSizeY1, tabSizeY2, tabSizeZ, holeRadius, (bottomTabOffset - armLength) / 2 + 5);
//	translate([-size.z - 0.75, -size.z - 0.75, 0])
//		rotate([-90, 0, 0]) {
//			color("silver") {
//				translate([(armLength + bottomTabOffset) / 2, 0, tabSizeZ])
//					rotate([0, 180, 0])
//						extrusionSlidingNut(sizeBottom, tabSizeY1, tabSizeY2, tabSizeZ, holeRadius, (bottomTabOffset - armLength) / 2 + 5);
//				translate([tabSizeZ, 0, (armLength + topTabOffset) / 2])
//					rotate([0, -90, 0])
//						extrusionSlidingNut(sizeTop, tabSizeY1, tabSizeY2, tabSizeZ, holeRadius,-(topTabOffset - armLength) / 2 - 5);
//				translate([0, -size.z / 2, 0]) {
//					cube([bottomTabOffset, size.z, size.z]);
//					cube([size.z, size.z, topTabOffset]);
//				}
//			}
//			if(grub_screws)
//			not_on_bom() no_explode() {
//				grubScrewLength = 6;
//				for(angle = [[0, 0, 0], [0, -90, 180]])
//				rotate(angle)
//					translate([armLength - 5, 0, size.z])
//						screw(M3_grub_screw, grubScrewLength);
//			}
//		}
//}
