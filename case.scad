
// exact measurements

pcb_width = 32.57;
pcb_length = 55.64;
pcb_thick = 1.52;

pcb_x_edge = pcb_width / 2;
pcb_y_edge = pcb_length / 2;

led_diameter = 5.88; // diameter of the lip on the bottom of the led.
led_radius = led_diameter / 2;

button_width = 6;

component_clearance = 4; // for resisters
lead_clearance = 3;

battery_size = [19.92,21.18,5.62 - pcb_thick];
battery_left_offset = 2.16;
battery_bottom_offset = 0.77;

clearance_padding = 1; // lip on the edge of the pcb

button_height = 5.11 - pcb_thick;
button_x = pcb_x_edge - 8.26;
 
led_positions = [pcb_y_edge - 7.54, pcb_y_edge - 17.50, pcb_y_edge - 27.84];

led_height = 9; // total highe of cylinder and cap hemisphere


battery_pos = [pcb_width/2 - battery_size[0] - battery_bottom_offset,-1 * pcb_length/2 + battery_left_offset];

intersection() {
  split();
  difference() {
    case();
    pcb();
  }
}

module split() {
  translate([-50,-50,pcb_thick]) cube([100,100,100]);
}

module case() {
  union() {
    translate([battery_pos[0],battery_pos[1],pcb_thick]) cube([battery_size[0] + 1, battery_size[1] + 1, battery_size[2] + 1]);
    translate([0,0,component_clearance - lead_clearance]) cube([pcb_width + 2, pcb_length + 2, pcb_thick + lead_clearance + component_clearance + 2],center=true);
  }
}

module pcb() {
  union() {

    // pcb
    color("green") translate([0,0,pcb_thick / 2]) cube([pcb_width, pcb_length, pcb_thick],center=true);

    // component room
    comp_clear_width = pcb_width - clearance_padding * 2;
    comp_clear_length = pcb_length - clearance_padding * 2;
    comp_clear_thick = component_clearance;
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
    led_offset = pcb_width/2 - 12 - led_diameter;
    led_offset_2 = pcb_length / 2 ;
    color("red") LED([led_offset,led_offset_2 - led_positions[0],pcb_thick]);
    color("blue") LED([led_offset,led_offset_2 - led_positions[1],pcb_thick]);
    color("green") LED([led_offset,led_offset_2 - led_positions[2],pcb_thick]);

    button_width = 6;
    button_offset = 2;
    button_position = pcb_width / 2 - button_width - button_offset;
    Button(button_width, [button_position,pcb_length/2 - led_positions[0] - button_width/2,pcb_thick]);
    Button(button_width, [button_position,pcb_length/2 - led_positions[1] - button_width/2,pcb_thick]);
    Button(button_width, [button_position,pcb_length/2 - led_positions[2] - button_width/2,pcb_thick]);
  }
}

module LED(position) {

  $fn = 20;

  cylinder_height = led_height - led_radius;
  translate(position)
    union() {
      cylinder(r=led_radius, h=cylinder_height);
      translate([0,0,cylinder_height]) sphere(r=led_radius);
    }
}

module Button(button_width, position) {
  color("black")
    translate(position)
      cube([button_width, button_width, button_height]);
}
