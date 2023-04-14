// An adapter to mount the BTT SKR3 board into Creality mounting holes.
// Aimed for the Sermoon D1.
// The SKR3 is mounted 90° compared to the Creality board.
// This way the cables fit in lenght and there is enough room for the USB connector.
// For mounting you need 4 * M3 heat inserts (OD=5mm, l=4mm).
// I recommend to replace the original screws from the old board with ones with a flatter head.
//
// Copyright (C) 2023 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "all"; // ["all", "mount"]

/* [Board Sizes] */
BoardLenght=109.7;
BoardWidth=84.3;

DrillLenght=101.85;
DrillWidth=76.3;
CrealityDrillDiameter=3.8;
// For M3 heat inserts use 4.5 else 2.5.
SkrDrillDiameter=4.5;
MountDiameter=9.5;

MountDistance=25;
MountHeight=5;
Thickness=3;

// Move SKR3 to the left
Offset_X=12;
// Move SKR3 to upper
Offset_Y=16;

/* [Options] */
UseFan=true;
FanDiameter=120;
FanScrewDistance=105;
// For M4 heat inserts use 5.4 else 3.5.
FanScrewDiameters=5.4;
FanMountingPostDiameter=14;
FanHeight=34;
// Move Fan to the left
FanOffset_X=2;

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

/* Creality holes */
// These are relative to the lower left corner of the board.
// I took them from the BTT E3 Mini board.
// https://github.com/bigtreetech/BIGTREETECH-SKR-mini-E3/blob/master/hardware/BTT%20SKR%20MINI%20E3%20V3.0.1/Hardware/BTT%20E3%20SKR%20MINI%20V3.0.1_SIZE.pdf

E3Mini=[103.75, 70.25];

UnkownDifference=-1.0;  // one hole was not correct, empiric fix with a slotted hole

Drill1=[23.4,67.03, 0];
Drill2=[85.55, E3Mini.y-3.02, 0];
Drill3=[5.54, 32.05, 0];
Drill4=[37.34, 29.41, 0];
Drill5=[101.22, 2.56, 0];

Rounding=MountDiameter/2;



///////////////////////////////////////////////////////////////////////////////
// Some helpers to round combined objects
module RoundConvex(r)
{
	offset(r = r)
	{
		offset(delta = -r)
		{
			children();
		}
	}
}

module RoundConcave(r)
{
	offset(r = -r)
	{
		offset(delta = r)
		{
			children();
		}
	}
}

module RoundThis(r)
{
	RoundConcave(r) RoundConvex(r) children();
}

// Can round combined 2D objects and make them 3D
module RoundExtrude(r, h)
{
	linear_extrude(height = h)
		RoundThis(r) children();
}

///////////////////////////////////////////////////////////////////////////////
// long hole
module SlottedHole(d, h, length)
{
   translate([0, 0, h/2])
      cube(size=[length, d, h+Epsilon], center=true);
      
   for(x=[-length/2,length/2])
   {
      translate([x, 0, h/2])
      {
         cylinder(d=d, h=h+Epsilon, center=true);
      }
   }
}

///////////////////////////////////////////////////////////////////////////////
// Helper for mounting step down boards with MP1584EN

module PcbMount(size, pcb)
{
   len=size.x;
   width=size.y+6;
   screw_dia=1.8;

   difference()
   {
      translate([0,0,size.z/2])
         cube([len,width, size.z], center=true);

      translate([0,0,size.z])
         cube([len+Epsilon,size.y, 2*pcb], center=true);

      translate([0,0,size.z/2])
         cube([len+Epsilon,size.y-1, size.z+Epsilon], center=true);

      for(n=[-1,1])
      {
         for(m=[-1:0.4:1])
         {
            translate([m*(len/2-2),n*(width/2-1.5),size.z/2])
               cylinder(d=screw_dia, h=20*size.z, center=true);
         }
      }
   }
}

module StepDown_MP1584EN()
{
   PcbMount(size=[22.5, 17, 6], pcb=1.4);
}

///////////////////////////////////////////////////////////////////////////////
// The Fan

module Fan(h=25)
{
   for(a=[45:90:360-Epsilon])
   {
      rotate([0,0,a])
         translate([FanScrewDistance/1.414, 0, 0])
         {
            difference()
            {
               cylinder(d=FanMountingPostDiameter, h=h, center=true);
               translate([0,0,h/2])
                  cylinder(d=FanScrewDiameters, h=h, center=true);
            }
         }
   }
}

///////////////////////////////////////////////////////////////////////////////
// The adapter

module CrealityHoles(d, h=5*Thickness)
{
   translate(Drill1)
      cylinder(d=d, h=h, center=true);
   translate(Drill2)
      cylinder(d=d, h=h, center=true);
   translate(Drill3)
      cylinder(d=d, h=h, center=true);
   translate(Drill4)
      cylinder(d=d, h=h, center=true);
   translate(Drill5)
      cylinder(d=d, h=h, center=true);
// fix some unknown difference in hole position
   translate([0,UnkownDifference,-h/2])
      translate(Drill5)
         rotate([0,0,90])
            SlottedHole(d=d, h=h, length=d/2);
}

module SKR3Holes()
{
      for(x=[-1,1])
      {
         for(y=[-1,1])
         {
            translate([x*DrillLenght/2, y*DrillWidth/2, 0])
               cylinder(d=SkrDrillDiameter, h=10*Thickness);
         }
      }
}

module BasePlate()
{
   r=UseFan ? FanMountingPostDiameter/2 : Rounding;
   RoundExtrude(r, Thickness)
   {
      rotate([0,0,90])
         square([BoardLenght+1.5, BoardWidth+1.5], center=true);
      x=E3Mini.x+32;
      y=E3Mini.y+7;
      translate([-x/4, y/2-BoardLenght/2-2])
         square([x/2, y], center=true);
      translate([x/4-15, y/2-BoardLenght/2+8])
         square([x/2, y], center=true);
      translate([x/4, y/8-BoardLenght/2-2])
         square([x/2, y/4], center=true);
      
      if(UseFan)
      {
         size=FanDiameter-1;
         translate([-FanOffset_X, 0])
            square([size, size], center=true);
      }
   }
}

module CoolingHelper()
{
   RoundExtrude(Rounding, 10*Thickness)
   {
      translate([7, 4])
         square([35,85],center=true);

      translate([7, 20-DrillWidth/2])
         square([70,53],center=true);
   }
}

module BoardHolder()
{
   BasePlate();
   rotate([0,0,90])
   {
      for(x=[-1,1])
      {
         for(y=[-1,1])
         {
            translate([x*DrillLenght/2, y*DrillWidth/2, MountHeight/2+Thickness])
               cylinder(d=MountDiameter-1.5, h=MountHeight, center=true);
            translate([x*DrillLenght/2, y*DrillWidth/2, MountHeight/2+Thickness-1])
               cylinder(d=MountDiameter, h=MountHeight-2, center=true);
         }
      }
   }
}

module Adapter()
{
   difference()
   {
      union()
      {
         BoardHolder();
         extra=4.5;
         for(n=[0,-1])
         {
            translate([-E3Mini.x/2-extra, n*34+3, Thickness/2])
               rotate([0,0,90])
                  StepDown_MP1584EN();
         }
      }

      translate([0,0, Thickness])
         rotate([0,0,90])
            SKR3Holes();
      
      translate([-E3Mini.x/2+Offset_X, -E3Mini.y/2-Offset_Y, 0])
         CrealityHoles(CrealityDrillDiameter);

      dept=Thickness;
      translate([-E3Mini.x/2+Offset_X, -E3Mini.y/2-Offset_Y, 0])
         CrealityHoles(6.5,dept);
      
      // improve cooling
      translate([0,0,-Epsilon])
         CoolingHelper();
   }
   if(UseFan)
   {
      translate([-FanOffset_X,0, FanHeight/2+Thickness])
         Fan(h=FanHeight+Epsilon);
      // improve cooling underneat the board
      translate([FanScrewDistance/2+FanMountingPostDiameter/2-2/2-FanOffset_X, 0, MountHeight/2+Thickness])
         cube([2, FanScrewDistance, MountHeight], center=true);
   }
}

module print(what="all")
{
   if(what == "all")
   {
      Adapter();
   }
}

print(PrintThis);
