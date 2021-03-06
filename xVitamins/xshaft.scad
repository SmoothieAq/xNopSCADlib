
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/rod.scad>
use <../xNopSCADlib/vitamins/carbon_tube.scad>

function xshaft_material(type)		= type[2];
function xshaft_diameter(type)		= type[3];
function xshaft_inner_diameter(type)= type[4];
function xshaft_length(type)		= type[5];

function axshaft(shaft, material, d, id, l) = axcreate(shaft, [material, d, id, l], 2);
function axPin(d, l) = axshaft([str("M",d,"_pin"),str("M",d," pin")],RodSteel, d=d, l=l);
function axSteelRod(d, l) = axshaft([str("Smooth_rod"),str("Smooth rod")],RodSteel, d=d, l=l);
function axCarbonTube(od, id, l) = axshaft([str("Carbon_tube"),str("Carbon tube")],RodCarbonTube, d=od, id=nnv(id,od-1), l=l);

module xshaft(shaft, l) {
	length = nnv(l, xshaft_length(shaft));
	if (xshaft_material(shaft) == RodCarbonTube)
		carbon_tube(xshaft_diameter(shaft), xshaft_inner_diameter(shaft), length);
	else
		rod(xshaft_diameter(shaft), length, center = false);
}

