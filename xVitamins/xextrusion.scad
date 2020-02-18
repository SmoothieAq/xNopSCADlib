
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/extrusion.scad>

function xextrusion_material(type)			= nnv(type[10], MaterialAluminium);
function xextrusion_has_corner_hole(type)	= nnv(type[11], false);
function xextrusion_length(type)			= type[12];

function axextrusion(xextrusion, l, material, has_corner_hole) = axcreate(xextrusion, [material, has_corner_hole, l], 10);

module xextrusion(extrusion, l) {
	length = nnv(l, xextrusion_length(type));
	color(material_color(xextrusion_material(type)))
		extrusion(extrusion, length, xextrusion_has_corner_hole(extrusion));
}

