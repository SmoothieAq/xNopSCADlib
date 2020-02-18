include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/screw.scad>
use <NopSCADlib/vitamins/nut.scad>
use <NopSCADlib/vitamins/insert.scad>
use <NopSCADlib/vitamins/inserts.scad>
use <../xVitamins/xscrew.scad>
use <../xVitamins/xnut.scad>
use <../xVitamins/xextrusion.scad>
use <../xVitamins/xtslot_nut.scad>
use <../xNopSCADlib/vitamins/tslot_nut.scad>
use <../xNopSCADlib/vitamins/tslot_nuts.scad>


function xxscrew_translate(type) 	= nnv(type[22], [0,0,0]);
function xxscrew_rotate(type)	 	= nnv(type[23], [0,0,0]);
function xxscrew_washer(type) 		= nnv(type[24], $screw_washer) == true ? screw_washer(type) : type[24];
function xxscrew_depth(type) 		= nnv(type[25], $screw_depth);
function xxscrew_nut(type)	 		= type[26] == true || (type[26] == undef && !type[34] && !type[35] && !type[36]) ? xscrew_nut(type) : type[26];
function xxscrew_nut_washer(type) 	= nnv(type[27], $nut_washer) == true ? nut_washer(xxscrew_xnut(type)) : type[27];
function xxscrew_nut_depth(type) 	= nnv(type[28], $nut_depth);
function xxscrew_twist(type) 		= type[29];
function xxscrew_thick(type)	 	= type[30];
function xxscrew_spacing(type)	 	= nnv(type[31], $screw_spacing);
function xxscrew_nut_spacing(type) 	= nnv(type[32], $nut_spacing);
function xxscrew_horizontal(type) 	= type[33];
function xxscrew_tslot_nut(type)	= type[34] == true || type[35] ? axtslot_nut(extrusion_screw_tslot_nut(type[35], type, true), material = xextrusion_material(type[35])) : type[34];
function xxscrew_extrusion(type)	= type[35];
function xxscrew_insert(type)		= type[36] == true ? screw_insert(type) : type[36];
function xxscrew_flip(type)			= nnv(type[37], xxscrew_rotate(type).x == 90);
function xxscrew_plate(type)		= nnv(type[38],$screw_plate);
function xxscrew_nut_plate(type)	= nnv(type[39],$nut_plate);

function xxscrew_def(type) = str(xscrew_def(type),", translate=",type[22],", rotate=",type[23],", washer=",is_bool(type[24]) ? type[24] : type[24][0],
	", depth=",type[25],", nut=",is_bool(type[26]) ? type[26] : type[26][0],", nut_washer=",is_bool(type[27]) ? type[27] : type[27][0],
	", nut_depth=",type[28],", twist=",type[29],", thick=",type[30],", spacing=",type[31],", nut_spacing=",type[32],", horizontal=",type[33],
	", tslot_nut=",is_bool(type[34]) ? type[34] : type[34][0],", extrusion=",type[35],", insert=",is_bool(type[36]) ? type[36] : type[36][0],
	", flip=",type[37],", plate=",type[38],", nut_plate=",type[39]
);

function xxscrew_fastner_type(type) = type[36] ? FastnerInsert : type[34] || type[45] ? FastnerTslot_nut : type[26] != false ? FastnerNut : 0;
function xxscrew_fastner_leng(type) =
	type[36] ? insert_length(xxscrew_insert(type)) :
	type[34] || type[45] ? tslot_nut_height(xxscrew_tslot_nut(type)) :
	type[26] != false ? let(washer = xxscrew_nut_washer(type)) (washer ?  washer_thickness(washer) : 0) + (1 - xxscrew_nut_depth(type)) * xnut_thickness(xxscrew_nut(type)):
	0;
function xxscrew_head_leng(type) = let(washer = xxscrew_washer(type)) (washer ?  washer_thickness(washer) : 0) - xxscrew_depth(type) * screw_head_height(type);

function axxscrew(xscrew, l, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) =
	axcreate(l ? axscrew(xscrew, l = l) : xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate], 22);

function axxscrew_setLeng(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		xleng = screw_longer_than(thick - xxscrew_head_leng(type) + xxscrew_fastner_leng(type) * 0.8)
	)
	axscrew(axxscrew, l = xleng);

//function axxscrew_setLengAdjustDepth(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal) = let (
//		lup = screw_longer_than(thick)
//		axscrew = axscrew(xscrew, l = screw_longer_than(thick))
//	)
//	axxscrew(axscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal);
//
//function axxscrew_setLengAdjustThick(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal) =
//axcreate(xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal], "xxscrew", "xscrew");
//
//function axxscrew_setLengAdjustDepthAndThick(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal) =
//axcreate(xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal], "xxscrew", "xscrew");
//
//function axxscrew_setLengAdjustThickUp(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal) =
//axcreate(xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal], "xxscrew", "xscrew");
//
//function axxscrew_setLengAdjustThickDown(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal) =
//axcreate(xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal], "xxscrew", "xscrew");

module xxscrew(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xwasher = xxscrew_washer(screw);
	xscrew(screw, depth = xxscrew_depth(screw), washer = xwasher);
	if (xwasher)
		translate([0, 0,- nnv(depth, 0) * screw_head_height(screw)])
			xwasher(xwasher);
}

module xxfastner(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	if (xtype == FastnerInsert) {
		xinsert = xxscrew_insert(screw);
		translate([0, 0, -xxscrew_thick(screw) - insert_length(xinsert)])
			insert(xinsert);
	} else if (xtype == FastnerTslot_nut) {
		translate([0, 0, -xxscrew_thick(screw)])
			rotate([180, 0, 0])
				xtslot_nut(xinsert);
	} else if (xtype == FastnerNut) {
		xwasher = xxscrew_nut_washer(screw);
		xnut = xxscrew_nut(screw);
		xdepth = xxscrew_nut_depth(screw);
		translate([0, 0, -xxscrew_thick(screw)])
			rotate([180, 0, 0]) {
				xnut(xnut, depth = xdepth, washer = xwasher, twist = xxscrew_twist(screw), horizontal = xxscrew_horizontal(screw));
				if (xwasher)
					translate([0, 0, xdepth * xnut_thickness(xnut)])
						xwasher(xwasher);
			}
	}
}

module xxscrew_plate(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xscrew_plate(screw, depth = xxscrew_depth(screw), plate = xxscrew_plate(screw), washer = xxscrew_washer(screw));
}

module xxscrew_hole(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xscrew_hole(screw, depth = xxscrew_depth(screw), spacing = xxscrew_spacing(screw), washer = xxscrew_washer(screw), horizontal = xxscrew_horizontal(screw));
}

module xxfastner_plate(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	if (xtype == FastnerNut) {
		xnut_plate(xxscrew_nut(screw), depth = xxscrew_nut_depth(screw), plate = xxscrew_nut_plate(screw), washer = xxscrew_nut_washer(screw));
	}
}

module xxfastner_hole(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	if (xtype == FastnerInsert) {
		translate([0, 0, -xxscrew_thick(screw)])
			insert_hole(xxscrew_insert(screw), horizontal = xxscrew_horizontal(screw));
	} else if (xtype == FastnerNut) {
		xnut_hole(xxscrew_nut(screw), depth = xxscrew_nut_depth(screw), spacing = xxscrew_nut_spacing(screw), washer = xxscrew_washer(screw), twist = xxscrew_twist(screw), horizontal = xxscrew_horizontal(screw));
	}
}

module xxside1(screws) {
	for (screw = screws)
		if (!xxscrew_flip(screw))
			xxscrew(screw);
		else
			xxfastner(screw);
}

module xxside2(screws) {
	for (screw = screws)
		if (xxscrew_flip(screw))
			xxscrew(screw);
		else
			xxfastner(screw);
}

module xxside1_plate(screws) {
	for (screw = screws)
		if (!xxscrew_flip(screw))
			xxscrew_plate(screw);
		else
			xxfastner_plate(screw);
}

module xxside2_plate(screws) {
	for (screw = screws)
		if (xxscrew_flip(screw))
			xxscrew_plate(screw);
		else
			xxfastner_plate(screw);
}

module xxside1_hole(screws) {
	for (screw = screws)
		if (!xxscrew_flip(screw))
			xxscrew_hole(screw);
		else
			xxfastner_hole(screw);
}

module xxside2_hole(screws) {
	for (screw = screws)
		if (xxscrew_flip(screw))
			xxscrew_hole(screw);
		else
			xxfastner_hole(screw);
}

module xxpart1(screws, color, noscrew) {
	module part()
		difference() {
			union() {
				children();
				xxside1_plate(screws);
			}
			xxside1_hole(screws);
		}

	if (!noscrew)
		xxside1(screws);
	if (!color)
		part() children();
	else
		color(color) part() children();
}

module xxpart2(screws, color, noscrew) {
	module part()
	difference() {
		union() {
			children();
			xxside2_plate(screws);
		}
		xxside2_hole(screws);
	}

	if (!noscrew)
		xxside2(screws);
	if (!color)
	part() children();
	else
		color(color) part() children();
}
