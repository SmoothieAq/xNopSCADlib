
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/extrusion.scad>

function xextrusion_material(type)			= nnv(type[10], MaterialAluminium);
function xextrusion_has_corner_hole(type)	= nnv(type[11], false);
function xextrusion_length(type)			= type[12];
function xextrusion_nut(type,hammer=false,screwr=4)	= nnv(type[13],hammer?xextrusion_hammer_nut(type,screwr):xextrusion_sliding_nut(type,screwr));
function xextrusion_hammer_nut(type,screwr=4)	= nnv(type[14],axextrusion_nut(type,hammer=true,screwr=screwr));
function xextrusion_sliding_nut(type,screwr=4)	= nnv(type[15],axextrusion_nut(type,hammer=false,screwr=screwr));

function axextrusion(xextrusion, l, material, has_corner_hole) = axcreate(xextrusion, [material, has_corner_hole, l], 10);

function axextrusion_nut(type,hammer=false,screwr=4) =
	let(
		e = extrusion_width(type)/10-2,
		t = [5,6,9.6][e],
		sx = [11.5,15.6,10.3][e],
		ty1 = [10.5,16,20][e],
		ty2 = [5.9,7.9,7.9][e]
	)
	axnut([str("M",screwr,hammer?"_hammer_nut":"sliding_t_nut"),screwr,ty2,t,t,false,0,sx,ty1,ty2,hammer],xextrusion_material(type)==MaterialAluminium?MaterialSteel:xextrusion_material(type));

module xextrusion(extrusion, l) {
	length = nnv(l, xextrusion_length(extrusion));
	color(material_color(xextrusion_material(extrusion)))
		extrusion(extrusion, length, xextrusion_has_corner_hole(extrusion));
}

