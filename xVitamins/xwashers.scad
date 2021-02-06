
include <NopSCADlib/vitamins/washers.scad>

use <xwasher.scad>

//
// Washers
//
//                             s    d    t    s       s       s    s   p
//                             c    i    h    o       t       p    p   e
//                             r    a    i    f       a       r    r   n
//                             e    m    c    t       r       i    i   n
//                             w    e    k                    n    n   y
//                                  t    n            d       g    g
//                                  e    e            i                v
//                                  r    s            a       d    t   e
//                                       s                    i    h   r
//                                                            a    k
//M3_washer       = ["M3",       3,   7,   0.5, false,  5.8,  5.6, 1.0, M3_penny_washer]
M3_washer_small   = ["M3",       3,   6,   0.7, false,  undef,  undef, undef, undef];
M3_washer_small_thick= ["M3",    3,   6,   1.0, false,  undef,  undef, undef, undef];
M3_washer_thin    = ["M3",       3,   7,   0.5, false,  undef,  undef, undef, undef];