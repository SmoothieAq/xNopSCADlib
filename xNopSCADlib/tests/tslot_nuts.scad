
include <../core.scad>

include <../vitamins/tslot_nuts.scad>

module tslot_nuts()
for(y = [0 : len(tslot_nuts_list) -1])
	for(x = [0 : len(tslot_nuts_list[y]) -1]) {
		tslot_nut = tslot_nuts_list[y][x];
		if (tslot_nut)
			translate([x * 20, y * 20, 0])
				tslot_nut(tslot_nut);
	}

if($preview)
	tslot_nuts();
