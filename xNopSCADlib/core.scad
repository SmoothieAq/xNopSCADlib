
include <NopSCADlib/core.scad>
include <NopSCADlib/utils/core/global.scad>
include <global_defs.scad>

function material_name(material) = ["?","Steel","Steel Black","Nylon","Brass","Aluminium","Carbon","Rubber","Printed","?","?"][material];
function material_color(material) = [undef,grey70,black_screw_colour,grey30,brass,grey80,carbon_colour,grey20,[0.1, 0.1, 0.7],undef,undef][material];

include <../xUtil/xUtil.scad>