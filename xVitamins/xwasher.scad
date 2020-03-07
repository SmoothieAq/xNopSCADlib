
include <../xNopSCADlib/core.scad>

use <NopSCADlib/vitamins/washer.scad>

function xwasher_material(type)		= nnv(type[10], type[11] == WasherSoft ? MaterialRubber : type[11] == WasherStar ? MaterialBrass : type[11] == WasherPrinted ? MaterialPrinted : MaterialSteel);
function xwasher_type(type)			= nnv(type[11], washer_soft(type) ? WasherSoft : type[10] == MaterialPrinted ? WasherPrinted : WasherHard);
function xwasher_printed_name(type)	= nnv(type[12], false);
function xwasher_thickness(type)	= xwasher_type(type) == WasherPenny ? xwasher_thickness(penny_washer(type)) : washer_thickness(type);

function axwasher(washer, material, nyloc) = axcreate(washer, [material, type, printed_name], 10);

module xwasher(washer, type) {
	xtype = nnv(type, xwasher_type(washer));
	colorize(material_color(xwasher_material(washer)))
		explode(xwasher_thickness(washer) * 6)
			if (xtype == WasherSoft) {
				assert(washer_soft(washer));
				washer(washer);
			} else {
				assert(!washer_soft(washer));
				if (xtype == WasherHard) washer(washer);
				else if (xtype == WasherStar) star_washer(washer);
				else if (xtype == WasherSpring) spring_washer(washer);
				else if (xtype == WasherPenny) penny_washer(washer);
				else if (xtype == WasherPrinted) printed_washer(washer, xwasher_printed_name(washer));
			}
}
