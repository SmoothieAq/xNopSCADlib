
include <ex1_main.scad>
use <animateSCAD/animateSCAD/animateSCAD.scad>

$fps = 5;
$frameNo = undef;
$showPath = 0;

$xanimation = [
	["part_bottom",5],
	["main",5]
];

cpoints = concat([cpoint("start")], [ for (p = $xanimation) cpoint(p[0],time=p[1]) ]);

$xcurrent_assembly = "part_bottom";
$xfraction = 0.5;
$xshowing_assembly = undef;



$camera = camera(cpoints=cpoints);

$vpd = $camera[0];
$vpr = $camera[1];
$vpt = $camera[2];


animation() main_assembly();
