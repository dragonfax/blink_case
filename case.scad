
pcb_size = [33,56,1];
battery_size = [21,21,4];
battery_left_offset = 2;
battery_bottom_offset = 1;


lead_clearance = 2;
component_clearance = 3; // for resisters
clearance_padding = 1; // lip on the edge of the pcb


pcb_width = pcb_size[0];
pcb_length = pcb_size[1];
pcb_thick = pcb_size[2];

battery_pos = [pcb_width/2 - battery_size[0] - battery_bottom_offset,-1 * pcb_length/2 + battery_left_offset];

union() {
  translate([battery_pos[0],battery_pos[1],pcb_thick]) cube([battery_size[0] + 1, battery_size[1] + 1, battery_size[2] + 1]);
difference() {
  cube([pcb_width + 2, pcb_length + 2, 10],center=true);
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
  translate([0,0, lead_clear_thick / 2 - pcb_thick])
    cube([
        comp_clear_width,
        comp_clear_length,
        lead_clear_thick
    ], center=true);
  translate([10, -pcb_length / 2, -pcb_thick]) cube([4,lead_clearance,pcb_thick]);

  // battery pack
  color("lightblue") translate([battery_pos[0],battery_pos[1],pcb_thick]) cube(battery_size);

  // leds
  led_positions = [7, 17, 27];
  led_width = 5;
  led_offset = pcb_width/2 - 12 - led_width;
  led_offset_2 = pcb_length / 2 ;
  color("red") LED(led_width,[led_offset,led_offset_2 - led_positions[0],pcb_thick]);
  color("blue") LED(led_width,[led_offset,led_offset_2 - led_positions[1],pcb_thick]);
  color("green") LED(led_width,[led_offset,led_offset_2 - led_positions[2],pcb_thick]);

  button_width = 6;
  button_offset = 2;
  button_position = pcb_width / 2 - button_width - button_offset;
  Button(button_width, [button_position,pcb_length/2 - led_positions[0] - button_width/2,pcb_thick]);
  Button(button_width, [button_position,pcb_length/2 - led_positions[1] - button_width/2,pcb_thick]);
  Button(button_width, [button_position,pcb_length/2 - led_positions[2] - button_width/2,pcb_thick]);
}
}
}

module LED(led_width,position) {
  led_height = 9; // total highe of cylinder and cap hemisphere

  $fn = 20;

  led_radius = led_width / 2;
  cylinder_height = led_height - led_radius;
  translate(position)
    union() {
      cylinder(r=led_width/2, h=cylinder_height);
      translate([0,0,cylinder_height]) sphere(r=led_width/2);
    }
}

module Button(button_width, position) {
  button_height = 5;
  color("black")
    translate(position)
      cube([button_width, button_width, button_height]);
}
