
include <NopSCADlib/vitamins/extrusions.scad>

use <xextrusion.scad>

function find_extrusion(w, i = 0) =
	i >= len(extrusions) ? undef
	: extrusion_width(extrusions[i]) == w ? extrusions[i]
	: find_extrusion(w, i + 1);
