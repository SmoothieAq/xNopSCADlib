
include <../xNopSCADlib/core.scad>

include <xextrusions.scad>
include <../xxVitamins/xxscrews.scad>
include <xnuts.scad>
use <NopSCADlib/vitamins/extrusion_bracket.scad>

function xextrusion_bracket_inner(type)			= nnv(type[5], !type[4]);
function xextrusion_bracket_material(type)		= nnv(type[6], MaterialAluminium);
function xextrusion_bracket_extrusion(type)		= nnv(type[7], find_extrusion(extrusion_corner_bracket_size(type).z));
function xextrusion_bracket_nut(type)			= nnv(type[8], xextrusion_nut(xextrusion_bracket_extrusion(type)));
function xextrusion_bracket_screw(type)			= nnv(type[9], xextrusion_bracket_find_screw(type));


function axextrusion_bracket(xextrusion_bracket, inner, material, extrusion, nut, screw) = axcreate(xextrusion_bracket, [inner, material, extrusion, nut, screw], 5);

function xextrusion_bracket_find_screw(type,stype=hs_dome) =
let(
	nut = xextrusion_bracket_nut(type),
	size = nut_size(nut),
	thick = extrusion_corner_bracket_base_thickness(type),
	xscrew = axscrew(find_screw(stype, size),material=xextrusion_bracket_material(type))
)
axxscrew_setLeng(xscrew,thick=thick,xnut=nut,nut_depth=0); // todo washer

function xextrusion_bracket_xxscrews(type) =
	let(
		o = extrusion_corner_bracket_hole_offset(type),
		t = extrusion_corner_bracket_base_thickness(type)
	)
	[ for (tr = [[[o,t,0],[-90,0,0]],[[t,o,0],[90,0,90]]]) axxscrew(xextrusion_bracket_screw(type),xnut=xextrusion_bracket_nut(type),r=tr.y,t=tr.x)];

module xextrusion_bracket(type, assembly=false) {
	ew2 = extrusion_width(xextrusion_bracket_extrusion(type))/2;
	translate([ew2,0,0])
		rotate([90, 0, 0])
			explode([ew2,0,0], explode_children = true)  {
				color(material_color(xextrusion_bracket_material(type)))
					if (xextrusion_bracket_inner(type))
						extrusion_inner_corner_bracket(type);
					else
						extrusion_corner_bracket(type);
				if (assembly) {
					screws = xextrusion_bracket_xxscrews(type);
					xxpart1fasten(screws);
					xxpart2fasten(screws); echo(xxscrew_nut(screws[0]),xnut_descr(xxscrew_nut(screws[0])));
				}
			}
}

module xextrusion_bracket_assembly(type) {
	xextrusion_bracket(type, assembly=true);
}