
//
//! Carbon tube.
//
include <../core.scad>

carbon_tube_colour = carbon_colour;

module carbon_tube(od, id , l) { //! Draw a carbon tube with specified length and outer and inner diameter
	vitamin(str("carbon_tube(", od, ", ", id, ", ", l, "): Carbon tube ", od, "/", id, "mm x ", l, "mm"));

	color(carbon_tube_colour)
		difference() {
			cylinder(d = od, h = l, center = true);

			cylinder(d = id, h = l+2, center = true);
		}
}

