
//
// T-slot nut
//                                      w    h    l     tw  th sd dropin extrusion
E20M3DropIn 	= [ "E20-M3 drop in", 10.3, 5.0,  6  ,  5.5, 2, 3, true,  20];
E20M4DropIn 	= [ "E20-M4 drop in", 10.3, 5.0,  6  ,  5.5, 2, 4, true,  20];
E20M5DropIn 	= [ "E20-M5 drop in", 10.3, 5.0,  6  ,  5.5, 2, 5, true,  20];
E30M3DropIn 	= [ "E30-M3 drop in", 15.5, 6.5,  8  ,  7.5, 2, 3, true,  30];
E30M4DropIn 	= [ "E30-M3 drop in", 15.5, 6.5,  8  ,  7.5, 2, 4, true,  30];
E30M5DropIn 	= [ "E30-M3 drop in", 15.5, 6.5,  8  ,  7.5, 2, 5, true,  30];
E30M6DropIn 	= [ "E30-M3 drop in", 15.5, 6.5,  8  ,  7.5, 2, 6, true,  30];
E40M4DropIn 	= [ "E40-M4 drop in", 19.5, 7.5,  8  ,  9.5, 3, 4, true,  40];
E40M5DropIn 	= [ "E40-M5 drop in", 19.5, 7.5,  8  ,  9.5, 3, 5, true,  40];
E40M6DropIn 	= [ "E40-M6 drop in", 19.5, 7.5,  8  ,  9.5, 3, 6, true,  40];
E20M3       	= [ "E20-M3"        , 10.3, 5.0, 11.5,  5.5, 2, 3, false, 20];
E20M4       	= [ "E20-M4"        , 10.3, 5.0, 11.5,  5.5, 2, 4, false, 20];
E20M5       	= [ "E20-M5"        , 10.3, 5.0, 11.5,  5.5, 2, 5, false, 20];
E30M3       	= [ "E30-M3"        , 15.5, 6.5, 15.6,  7.5, 2, 3, false, 30];
E30M4       	= [ "E30-M4"        , 15.5, 6.5, 15.6,  7.5, 2, 4, false, 30];
E30M5       	= [ "E30-M5"        , 15.5, 6.5, 15.6,  7.5, 2, 5, false, 30];
E30M6       	= [ "E30-M6"        , 15.5, 6.5, 15.6,  7.5, 2, 6, false, 30];
E40M4       	= [ "E40-M4"        , 19.5, 7.5, 19.3,  9.5, 3, 4, false, 40];
E40M5       	= [ "E40-M5"        , 19.5, 7.5, 19.3,  9.5, 3, 5, false, 40];
E40M6       	= [ "E40-M6"        , 19.5, 7.5, 19.3,  9.5, 3, 6, false, 40];

tslot_nuts_list = [
	[E20M3DropIn, E20M4DropIn, E20M5DropIn, E30M3DropIn, E30M4DropIn, E30M5DropIn, E30M6DropIn, E40M4DropIn, E40M5DropIn, E40M6DropIn],
	[E20M3, E20M4, E20M5, E30M3, E30M4, E30M5, E30M6, E40M4, E40M5, E40M6]
];

tslot_nuts = concat(tslot_nuts_list[0], tslot_nuts_list[1]);

use <NopSCADlib/vitamins/extrusion.scad>
use <NopSCADlib/vitamins/screw.scad>

function extrusion_screw_tslot_nut(extrusion, screw, drop_in = true) =
	[ for(type = tslot_nuts) if (extrusion_width(extrusion) == type[8] && screw_radius(screw) == type[6] / 2 && drop_in == type[7]) type ][0];

use <tslot_nut.scad>