
pcb_size = [20,40,1];
battery_size = [10,10,4];
battery_pos = [-5,-15];

lead_clearance = 1;
component_clearance = 2;
clearance_padding = 2;

pcb_width = pcb_size[0];
pcb_length = pcb_size[1];
pcb_thick = pcb_size[2];

union() {

  // pcb
  color("green") translate([0,0,pcb_thick / 2]) cube(pcb_size,center=true);

  // component room
  comp_clear_width = pcb_size[0] - clearance_padding * 2;
  comp_clear_length = pcb_size[1] - clearance_padding * 2;
  comp_clear_thick = component_clearance + pcb_thick;
  translate([0,0,comp_clear_thick / 2]) 
    cube([
      comp_clear_width,
      comp_clear_length,
      comp_clear_thick
    ],center=true);

  // leads room
  lead_clear_thick = lead_clearance + pcb_thick;
  translate([0,0, led_clear_thick / 2 - pcb_thick])
    cube([
        comp_clear_width,
        comp_clear_length,
        lead_clear_thick
    ], center=true);

  // battery pack
  color("lightblue") translate([battery_pos[0],battery_pos[1],pcb_thick]) cube(battery_size);

  // leds
  color("red") LED([1,5,pcb_thick]);
  color("blue") LED([1,8,pcb_thick]);
  color("green") LED([1,11,pcb_thick]);
}

module LED(position) {
  led_height = 5;
  led_width = 2;
  translate(position)
    union() {
      cylinder(r=led_width/2, h=led_height);
      translate([0,0,led_height]) sphere(r=led_width/2);
    }
}
