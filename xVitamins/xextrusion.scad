
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/extrusion.scad>
include <xnuts.scad>
use <xextrusion_bracket.scad>

function xextrusion_material(type)			= nnv(type[10], MaterialAluminium);
function xextrusion_has_corner_hole(type)	= nnv(type[11], false);
function xextrusion_length(type)			= type[12];

function axextrusion(xextrusion, l, material, has_corner_hole, nut) = axcreate(xextrusion, [material, has_corner_hole, l], 10);

function xextrusion_nut(type,hammer=false,screwd=4) =
	let(
		e = extrusion_width(type)/10-2,
		t1 = [3.5,4.5,7.5][e], // TODO verify
		t2 = [5,6,9.6][e],
		sx = [11.5,15.6,10.3][e],
		ty1 = [10.5,16,20][e],
		ty2 = [5.9,7.9,7.9][e]
	)
	axnut([str("M",screwd,hammer?"_hammer_nut":"_sliding_t_nut"),screwd,ty2,t1,t2,false,0,sx,ty1,ty2,hammer],material=xextrusion_material(type)==MaterialAluminium?MaterialSteel:xextrusion_material(type));

function xextrusion_extrusion_bracket(type,inner=false) =// TODO inner
let(
	w = extrusion_width(type),
	e = w/10-2,
	s = [[28,28,20],[35,35,30]][e],
	bt = [2,4.5][e],
	st = [3,3][e],
	o = [19.5,19.5][e]
)
axextrusion_bracket([str("W",w,inner?"_inner_corner_bracket":"_corner_bracket"),s,bt,st,o],inner=inner,material=xextrusion_material(type),extrusion=type);

module xextrusion(extrusion, l) {
	length = nnv(l, xextrusion_length(extrusion));
	color(material_color(xextrusion_material(extrusion)))
		extrusion(extrusion, length, xextrusion_has_corner_hole(extrusion));
}

module xextrusion_assembly(extrusion,inner=false) {
	xextrusion(extrusion);
	bracket = xextrusion_extrusion_bracket(extrusion,inner=inner);
	xextrusion_bracket_assembly( bracket );
	translate([0,0,xextrusion_length(extrusion)])
		rotate([180,0,0])
			xextrusion_bracket_assembly( bracket );
}
