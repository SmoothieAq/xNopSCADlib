
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/rail.scad>

function xrail_material(type)		= nnv(type[13], MaterialSteel);
function xrail_length(type)			= type[14];

function axrail(xrail, l, material) = axcreate(xrail, [material, l], 13);

module xrail(rail, l) {
	length = nnv(l, xrail_length(rail));
	translate([length/2,0,0])
        color(material_color(xrail_material(rail)))
            rail(rail, length);
}

module xrail_assembly(rail, pos, l) {
    xrail(rail, l);
    xpos = nnv(pos, nnv(l, xrail_length(rail))/2);
    translate([xpos,0,0])
        carriage(rail_carriage(rail), rail);
}

function carriage_hole_ps(type) = let (
    x_pitch = carriage_pitch_x(type),
    y_pitch = carriage_pitch_y(type)
) [ for(x = [-1, 1], y = [-1, 1])  [x * x_pitch / 2, y * y_pitch / 2, carriage_height(type)] ];

function rail_hole_ps(type, length, first = 0, screws = 100, both_ends = true)  = let(
    leng = nnv(length,xrail_length(type)),
    pitch = rail_pitch(type),
    holes = rail_holes(type, leng),
    last = first + min(screws, both_ends ? ceil(holes / 2) : holes)
) [ for(i = [first : holes - 1], j = holes - 1 - i)
        if(i < last || both_ends && (j >= first && j < last))
            i * pitch + (leng - (holes - 1) * pitch) / 2 ];
