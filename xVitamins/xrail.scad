
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

