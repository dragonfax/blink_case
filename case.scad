
union() {
  translate([0,0,0.5]) cube([20,40,1],center=true);
  translate([0,0,1]) cube([18,38,4],center=true);
  color("lightblue") translate([-5,-15,2]) cube([10,10,4]);
  translate([1,5,0]) LED();
  translate([1,8,0]) LED();
  translate([1,11,0]) LED();
}

module LED() {
  union() {
    cylinder(r=1, h=5);
    translate([0,0,5]) sphere(r=1);
  }
}
