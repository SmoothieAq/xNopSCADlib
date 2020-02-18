
function axcreate(xbase, values, startIdx) = array_update(xbase, values, startIdx);

function array_set(v, idx, val) = [for (i = [0:len(v) - 1]) i == idx ? val : v[i]];

function array_update(v, vupdate, startIdx = 0) = echo("array_update", v, vupdate, startIdx)assert(v&&vupdate)[for (i = [0:max(len(v), len(vupdate) + startIdx) - 1]) i < startIdx && vupdate[i - startIdx] == undef ? v[i] : vupdate[i - startIdx] ];

function nnv(v, d) = v ? v : d;

module colorize(colour, onlyIf = true) {
	if (onlyIf && colour)
		color(colour) children();
	else
		children();
}

module xhole(r, h, horizontal) {
	translate([0, 0, h/2])
		if (horizontal)
			teardrop_plus(r = r, h = h);
		else
			poly_cylinder(r = r, h = h, center = true);
}