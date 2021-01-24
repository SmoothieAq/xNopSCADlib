
//! Project description in Markdown format before the first include.

$layer_height = 0.2;
$extrusion_width = 0.5;
$nozzle = 0.4;
include <xNopSCADlib/xxVitamins/xxDefaults.scad>
$show_threads=true;
$show_lines=false;
$explode = 1;
include <xNopSCADlib/xNopSCADlib/core.scad>
include <xNopSCADlib/xxVitamins/xxscrews.scad>

$debug=0;

screwPart = axscrew(M3_cap_screw,material=MaterialBlackSteel);

part1thickPref = 15;
part2thick = 7;

part2tr = [0,0,-part2thick];

partscrew = axxscrew_setLengAdjustThick(screwPart, thick=part1thickPref, insert=true, washer=true);
part1thick = xxscrew_thick(partscrew);
partScrews = [ for (y = [15, 25]) axxscrew(partscrew, t = [20, y, part1thick]) ];

module part1_stl() {
	stl("part1");
	xxpart1only(partScrews) cube([40, 40, part1thick]);
}

module part2_stl() {
	stl("part2");
	xxpart2only(partScrews, part2tr) cube([40, 40, part2thick]);
}

//! Bottom assembly, place the inserts into the holes in the lugs and press home with a soldering iron with a conical bit heated to 200&deg;C.
module part_bottom_assembly()
xassembly("part_bottom") {
	xelement() color("lightblue") part2_stl();
	xelement() xxpart2fasten(partScrews,part2tr);
}

//! Main assembly, screw it together
module main_assembly()
xassembly("main") {
	xelement() explode(20, explode_children = true) {
		color("darkblue") part1_stl();
		xxpart1fasten(partScrews);
	}
	xsubassembly() tr(part2tr) part_bottom_assembly();
}

if($preview && is_undef($animating)) {
	main_assembly();
}


module xassembly(name) {
	echo("*0",name,$xcurrent_assembly,$xshowing_assembly);
	assembly(name) {
		if (name == $xcurrent_assembly) {
			echo("*1");
			$xshowing_assembly = name;
			$exploded_fract = $xfraction;
			$exploded_parent = undef;
			children();
		} else {
			echo("*1");
			children();
		}
	}
}

module xelement() {
	if ($xcurrent_assembly == undef || $xshowing_assembly != undef)
		children();
}

module xsubassembly() {
	children();
}

