
include <NopSCADlib/core.scad>
include <NopSCADlib/utils/core/global.scad>
include <global_defs.scad>

function material_name(material) = ["?","Steel","Steel Black","Nylon","Brass","Aluminium","Carbon","Rubber","Printed","?","?"][material];
function material_color(material,col=undef) =
	col != undef ? col
	: [undef,grey(70),black_screw_colour,grey(30),brass,grey(80),carbon_colour,grey(20),[0.1, 0.1, 0.7],undef,undef][material];

include <../xUtil/xUtil.scad>