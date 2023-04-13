// A drilling jig for the BTT SKR3 board with Creality Sermoon D1.
// This is now superflows since I needed an adapter tp mount the SKR3 with 90°.
// Kept in case it migh be a good start for other pronters.
// Copyright (C) 2023 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "all"; // ["all", "mount"]

/* [Sizes] */
BoardLenght=109.7;
BoardWidth=84.3;

DrillLenght=101.85;
DrillWidth=76.3;
DrillDiameter=2;

MountDistance=25;
Thickness=1.5;

/* [Misc] */

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

module Jig()
{
   difference()
   {
      union()
      {
         cube([BoardLenght, BoardWidth, Thickness], center=true);
         translate([0,-BoardWidth/2-MountDistance/2,0])
            cube([BoardLenght, MountDistance+Epsilon, Thickness], center=true);
         // Stopper
         stopper_width=2;
         stopper_height=5;
         translate([0,-BoardWidth/2-MountDistance+stopper_width/2,stopper_height/2-Thickness/2])
            cube([BoardLenght, stopper_width+Epsilon, stopper_height], center=true);
      }
      for(x=[-1,1])
      {
         for(y=[-1,1])
         {
            translate([x*DrillLenght/2, y*DrillWidth/2, 0])
               cylinder(d=DrillDiameter, h=5*Thickness, center=true);
         }
      }
      translate([0, 0, 0])
         cube([0.8*BoardLenght, 0.8*BoardWidth, 5*Thickness], center=true);
      translate([0, -0.75*MountDistance/2-BoardWidth/2, 0])
         cube([0.85*BoardLenght, 0.75*MountDistance, 5*Thickness], center=true);
   }
}

module print(what="all")
{
   if(what == "all")
   {
      Jig();
   }
}

print(PrintThis);
