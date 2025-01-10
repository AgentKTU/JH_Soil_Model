// Gmsh project created on Fri Jan 10 11:46:38 2025
SetFactory("OpenCASCADE");
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {3, 0, 0, 1.0};
//+
Point(3) = {3, 3, 0, 1.0};
//+
Point(4) = {0, 3, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Point(5) = {1.5, 1.5, 0, 0.25};
//+
Point(6) = {1.51025, 1.5, 0, 0.2};
//+
Point(7) = {1.48975, 1.5, 0, 0.2};
//+
Circle(5) = {7, 5, 6};
//+
Circle(6) = {6, 5, 7};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Curve Loop(2) = {6, 5};
//+
Plane Surface(1) = {1, 2};
//+
Physical Curve("conductor", 7) = {5, 6};
//+
Physical Curve("top", 8) = {3};
//+
Physical Curve("left", 9) = {4};
//+
Physical Curve("right", 10) = {2};
//+
Physical Curve("bottom", 11) = {1};
//+
Physical Surface("soil", 12) = {1};
//+
Physical Point("conductor_point", 13) = {7, 6};
