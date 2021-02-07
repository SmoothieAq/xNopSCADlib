include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/screw.scad>
use <NopSCADlib/vitamins/nut.scad>
use <NopSCADlib/vitamins/insert.scad>
use <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/washer.scad>
use <../xVitamins/xscrew.scad>
use <../xVitamins/xnut.scad>
use <../xVitamins/xwasher.scad>
use <../xVitamins/xextrusion.scad>
use <../xVitamins/xtslot_nut.scad>
use <../xNopSCADlib/vitamins/tslot_nut.scad>
use <../xNopSCADlib/vitamins/tslot_nuts.scad>


function xxscrew_translate(type) 	= nnv(type[22], [0,0,0]);
function xxscrew_rotate(type)	 	= nnv(type[23], [0,0,0]);
function xxscrew_washer(type) 		= screw_head_type(type) == hs_cs_cap || screw_head_type(type) == hs_cs ? false : nnv(type[24], $screw_washer) == true ? screw_washer(type) : type[24];
function xxscrew_depth(type) 		= nnv(type[25], screw_head_type(type) == hs_cap ? $screw_depth : 0);
function xxscrew_nut(type)	 		= (type[26] == true || (type[26] == undef && !type[34] && !type[35] && !type[36])) ? xscrew_nut(type) : type[26];
function xxscrew_nut_washer(type) 	= nnv(type[27], $nut_washer) == true ? nut_washer(xxscrew_nut(type)) : type[27];
function xxscrew_nut_depth(type) 	= nnv(type[28], xxscrew_fastner_type(type) == FastnerNut ? $nut_depth : 0);
function xxscrew_twist(type) 		= type[29];
function xxscrew_thick(type)	 	= type[30];
function xxscrew_spacing(type)	 	= nnv(type[31], $screw_spacing);
function xxscrew_nut_spacing(type) 	= nnv(type[32], $nut_spacing);
function xxscrew_horizontal(type) 	= type[33];
function xxscrew_tslot_nut(type)	= type[34] == true || type[35] ? axtslot_nut(extrusion_screw_tslot_nut(type[35], type, true), material = xextrusion_material(type[35])) : type[34];
function xxscrew_extrusion(type)	= type[35];
function xxscrew_insert(type)		= type[36] == true ? screw_insert(type) : type[36];
function xxscrew_flip(type)			= nnv(type[37], xxscrew_rotate(type).x == 180);
function xxscrew_plate(type)		= nnv(type[38], $screw_plate);
function xxscrew_nut_plate(type)	= nnv(type[39], $nut_plate);

function xxscrew_names() = ["translate","rotate","washer","depth","nut","nut_washer","nut_depth","twist","thick","spacing","nut_spacing","horizontal","tslot_nut","extrusion","insert","flip","plate","nut_plate"];
function xxscrew_descr(type) = concat(xscrew_descr(type), _descr(type, xxscrew_names(), 22));

function xxscrew_fastner_type(type) = type[36] ? FastnerInsert : type[34] || type[35] ? FastnerTslot_nut : type[26] != false ? FastnerNut : 0;
function xxscrew_fastner_leng(type, grip, nutDepth) =
	type[36] ? insert_length(xxscrew_insert(type)) * grip :
	type[34] || type[35] ? tslot_nut_height(xxscrew_tslot_nut(type)) * grip :
	type[26] != false ? let(washer = xxscrew_nut_washer(type)) (washer ?  washer_thickness(washer) : 0) + (grip - nnv(nutDepth, xxscrew_nut_depth(type))) * xnut_thickness(xxscrew_nut(type)):
	0;
function xxscrew_head_leng(type, depth) = let(washer = xxscrew_washer(type)) (washer ?  washer_thickness(washer) : 0) - nnv(depth, xxscrew_depth(type)) * screw_head_height(type);

function axxscrew(xscrew, l, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) =
	axcreate(l ? axscrew(xscrew, l = l) : xscrew, [t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate], 22);

function axxscrew_setLeng(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, undef, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		xleng = screw_longer_than(xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew) + xxscrew_fastner_leng(axxscrew, 0.5))
	)
	echo("setLeng",axxscrew[0],thick=xxscrew_thick(axxscrew),xleng=xleng,head_leng=xxscrew_head_leng(axxscrew),fastner_leng=xxscrew_fastner_leng(axxscrew,0.5))
	axscrew(axxscrew, l = xleng);

function axxscrew_setLengAdjustDepth(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, undef, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		leng = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew) + xxscrew_fastner_leng(axxscrew, 0.8),
		xleng = screw_longer_than(leng),
		dd0 = [xxscrew_depth(axxscrew), xxscrew_nut_depth(axxscrew)],
		ddmin = [screw_head_type(axxscrew) == hs_cs_cap || screw_head_type(axxscrew) == hs_cs ? 0 : -0.2, xxscrew_fastner_type(axxscrew) != FastnerNut ? 0 : dd0[1] >= 0.99 ? 1 : -0.2],
		ddmax = [screw_head_type(axxscrew) == hs_cap ? 1.1 : 0, xxscrew_fastner_type(axxscrew) == FastnerNut ? 1.2 : 0],
		lengMin = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew, ddmax[0]) + xxscrew_fastner_leng(axxscrew, 0.45, ddmax[1]),
		xlengMin = screw_longer_than(lengMin),
		lengMax = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew, ddmin[0]) + xxscrew_fastner_leng(axxscrew, 0.99, ddmin[1]),
		xxleng = lengMax >= xleng && xleng - leng < abs(xlengMin - leng) * 0.8 ? xleng : xlengMin,
		aleng1 = leng - min(lengMax, xxleng),
		aleng2 = aleng1 - (aleng1 < 0 ?max(aleng1, xxscrew_fastner_leng(axxscrew, 0.8) - xxscrew_fastner_leng(axxscrew, 0.99)) : min(aleng1, xxscrew_fastner_leng(axxscrew, 0.8) - xxscrew_fastner_leng(axxscrew, 0.45))),
		dd1 = [ for (i = [0:1]) aleng2 < 0 ? ddmax[i] - dd0[i] : dd0[i] - ddmin[i] ],
		dd2 = let (s = dd1[0] + dd1[1]) [ for (d = dd1) if (s == 0) 0 else aleng2 / s * d ],
		dd3 = [screw_head_height(axxscrew) == 0 ? 0 : dd2[0] / screw_head_height(axxscrew), dd2[1] == 0 ? 0 : dd2[1] / xnut_thickness(xxscrew_nut(axxscrew))],
		dd4 = [ for (i = [0:1]) min(ddmax[i], max(ddmin[i],dd3[i] + dd0[i])) ]
	)
	echo("setLengAdjustDepth",axxscrew[0],thick=xxscrew_thick(axxscrew),leng=leng,lengMin=lengMin,lengMax=lengMax,xleng=xleng,xlengMin=xlengMin,xxleng=xxleng,aleng1=aleng1,aleng2=aleng2,dd0=dd0,ddmin=ddmin,ddmax=ddmax,dd1=dd1,dd2=dd2,dd3=dd3,dd4=dd4)
	axxscrew(axxscrew, l = xxleng, depth = dd4[0], nut_depth = dd4[1]);

function axxscrew_setLengAdjustThick(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, undef, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		leng = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew) + xxscrew_fastner_leng(axxscrew, 0.9),
		xlengLonger = screw_longer_than(leng),
		xlengShorter = screw_shorter_than(leng),
		xleng = xlengLonger - leng < leng - xlengShorter ? xlengLonger : xlengShorter,
		xthick = xxscrew_thick(axxscrew) + xleng - leng
	)
	echo("setLengAdjustThick",axxscrew[0],thick=xxscrew_thick(axxscrew),leng=leng,xleng=xleng,xthick=xthick)
	axxscrew(axxscrew, l = xleng, thick = xthick);

function axxscrew_setLengAdjustThickUp(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, undef, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		leng = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew) + xxscrew_fastner_leng(axxscrew, 0.9),
		xleng = screw_longer_than(leng),
		xthick = xxscrew_thick(axxscrew) + xleng - leng
	)
	axxscrew(axxscrew, l = xleng, thick = xthick);

function axxscrew_setLengAdjustThickDown(xscrew, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate) = let (
		axxscrew = axxscrew(xscrew, undef, t, r, washer, depth, xnut, nut_washer, nut_depth, twist, thick, spacing, nut_spacing, horizontal, tslot_nut, extrusion, insert, flip, plate, nut_plate),
		leng = xxscrew_thick(axxscrew) + xxscrew_head_leng(axxscrew) + xxscrew_fastner_leng(axxscrew, 0.9),
		xleng = screw_shorter_than(leng),
		xthick = xxscrew_thick(axxscrew) + xleng - leng
	)
	axxscrew(axxscrew, l = xleng, thick = xthick);


module xxscrew(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	if ($debug > 1) echo("xxscrew", xxscrew_descr(screw));
	assert(is_list(screw) && is_string(screw[0]), "The screw argument does not seem to be a xscrew nor a screw");
	xwasher = xxscrew_washer(screw);
	xscrew(screw, depth = xxscrew_depth(screw), washer = xwasher, twist = xxscrew_twist(screw), horizontal = xxscrew_horizontal(screw));
	if (xwasher)
		translate([0, 0,- xxscrew_depth(screw) * screw_head_height(screw)])
			xwasher(xwasher);
}

module xxfastner(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	if (xtype == FastnerInsert) {
		xinsert = xxscrew_insert(screw);
		translate([0, 0, -xxscrew_thick(screw)])
			insert(xinsert);
	} else if (xtype == FastnerTslot_nut) {
		xtslot_nut = xxscrew_tslot_nut(screw);
		translate([0, 0, -xxscrew_thick(screw)])
			rotate([180, 0, 0])
				xtslot_nut(xtslot_nut);
	} else if (xtype == FastnerNut) {
		xwasher = xxscrew_nut_washer(screw);
		xnut = xxscrew_nut(screw);
		xdepth = xxscrew_nut_depth(screw);
		translate([0, 0, -xxscrew_thick(screw)])
			rotate([180, 0, 0]) {
				xnut(xnut, depth = xdepth, washer = xwasher, twist = xxscrew_twist(screw), horizontal = xxscrew_horizontal(screw));
				if (xwasher)
					translate([0, 0, -xdepth * xnut_thickness(xnut)])
						xwasher(xwasher);
			}
	}
}

module xxscrew_plate(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xscrew_plate(screw, depth = xxscrew_depth(screw), plate = xxscrew_plate(screw), washer = xxscrew_washer(screw));
}

module xxscrew_hole(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xscrew_hole(screw, depth = xxscrew_depth(screw), spacing = xxscrew_spacing(screw), washer = xxscrew_washer(screw), horizontal = xxscrew_horizontal(screw), twist = xxscrew_twist(screw));
}

module xxfastner_plate(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	if (xtype == FastnerNut) {
		translate([0, 0, -xxscrew_thick(screw)])
			rotate([180, 0, 0])
				xnut_plate(xxscrew_nut(screw), depth = xxscrew_nut_depth(screw), plate = xxscrew_nut_plate(screw), washer = xxscrew_nut_washer(screw));
	}
}

module xxfastner_hole(screw) translate(xxscrew_translate(screw)) rotate(xxscrew_rotate(screw)) {
	xtype = xxscrew_fastner_type(screw);
	translate([0, 0, -xxscrew_thick(screw)])
	if (xtype == FastnerInsert) {
		insert_hole(xxscrew_insert(screw), horizontal = xxscrew_horizontal(screw));
	} else if (xtype == FastnerNut) {
		rotate([180, 0, 0])
			xnut_hole(xxscrew_nut(screw), depth = xxscrew_nut_depth(screw), spacing = xxscrew_nut_spacing(screw), washer = xxscrew_nut_washer(screw), twist = xxscrew_twist(screw), horizontal = xxscrew_horizontal(screw));
	}
}

module xxsides(screws) {
	xxside1(screws);
	xxside2(screws);
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
	for (screw = screws) {
		xxscrew_hole(screw);
		if (xxscrew_flip(screw))
			xxfastner_hole(screw);
	}
}

module xxside2_hole(screws) {
	for (screw = screws) {
		xxscrew_hole(screw);
		if (!xxscrew_flip(screw))
			xxfastner_hole(screw);
	}
}

module xxpart1only(screws) {
	difference() {
		union() {
			children();
			xxside1_plate(screws);
		}
		xxside1_hole(screws);
	}
}

module xxpart1fasten(screws) {
	xxside1(screws);
}

module xxpart1(screws, color, noscrew) {
	if (!noscrew)
		xxside1(screws);
	if (!color)
		xxpart1only(screws) children();
	else
		color(color) xxpart1only(screws) children();
}

module xxpart2only(screws, tr) {
	module p() difference() {
		union() {
			children();
			xxside2_plate(screws);
		}
		xxside2_hole(screws);
	}
	if (tr) rt(tr) p() tr(tr) children();
	else p() children();
}

module xxpart2fasten(screws, tr) {
	if (tr) rt(tr) xxside2(screws);
	else xxside2(screws);
}

module xxpart2(screws, color, noscrew) {
	if (!noscrew)
		xxside2(screws);
	if (!color)
		xxpart2only(screws) children();
	else
		color(color) xxpart2only(screws) children();
}
