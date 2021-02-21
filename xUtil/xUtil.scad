
function axcreate(xbase, values, startIdx) = array_update(xbase, values, startIdx);

function array_set(v, idx, val) = [for (i = [0:len(v) - 1]) i == idx ? val : v[i]];

function array_update(v, vupdate, startIdx = 0) = assert(v && vupdate) [ for (i = [0:max(len(v), len(vupdate) + startIdx) - 1]) i < startIdx || vupdate[i - startIdx] == undef ? v[i] : vupdate[i - startIdx] ];

function _descr(v, names, startIdx = 0) = [ for (i = [0:len(names)-1]) if (v[i + startIdx] != undef) str(names[i], "=" ,v[i + startIdx]) ];
function descr(v, names, startIdx = 0) = concat([str("type=",v[0])], _descr(v, names, startIdx));
function xdescr(descr, v) = concat(descr, v);

function debug(level, msg) = $debug < level ? 0 : echo("DEBUG", msg) 1;

module debug(level, msg) if ($debug >= level) echo("DEBUG", msg);

function nnv(v, d) = v != undef ? v : d;

module tr(t, r) {
	tr = t != undef ? [t.x, t.y, t.z] : [0, 0, 0];
	ro = r != undef ? [r.x, r.y, r.z] : (t != undef && len(t) > 3) ? [t[3], t[4], t[5]] : [0, 0, 0];
	if ( tr.x != 0 || tr.y != 0 || tr.z != 0 ) {
		if ( ro.x != 0 || ro.y != 0 || ro.z != 0 ) translate(tr) rotate(ro) children();
		else translate(tr) children();
	} else {
		if ( ro.x != 0 || ro.y != 0 || ro.z != 0 ) rotate(ro) children();
		else children();
	}
}

module rt(t, r) {
	tr = t != undef ? [-t.x, -t.y, -t.z] : [0, 0, 0];
	ro = r != undef ? [-r.x, -r.y, -r.z] : (t != undef && len(t) > 3) ? [-t[3], -t[4], -t[5]] : [0, 0, 0];
	if ( tr.x != 0 || tr.y != 0 || tr.z != 0 ) {
		if ( ro.x != 0 || ro.y != 0 || ro.z != 0 ) rotate([ro.x,0,0]) rotate([0,ro.y,0]) rotate([0,0,ro.z]) translate(tr) children();
		else translate(tr) children();
	} else {
		if ( ro.x != 0 || ro.y != 0 || ro.z != 0 ) rotate([ro.x,0,0]) rotate([0,ro.y,0]) rotate([0,0,ro.z]) children();
		else children();
	}
}

module colorize(colour, onlyIf = true) {
	if (onlyIf && colour)
		color(colour) children();
	else
		children();
}

module xhole(r, h, horizontal) {
	if (h)
		translate([0, 0, h/2])
			if (horizontal) {
				teardrop_plus(r = r, h = h);
			} else {
				poly_cylinder(r = r, h = h, center = true, sides = max(round(6*r), 3));
			}
}

function len2(vek2) = sqrt(sqr(vek2.x)+sqr(vek2.y));
function a2(vek2) = atan(vek2.y/vek2.x) - (vek2.x < 0 ? 180 : 0);
