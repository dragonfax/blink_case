
// exact measurements

pcb_size_x = 32.57;
pcb_size_y = 55.64;
pcb_size_z = 1.52;


components_size_z_above = 4; // for resisters
components_size_z_below = 3 - pcb_size_z; // for soldering points
components_clearance = 1; // lip on edge

components_size_x = pcb_size_x - 2 * components_clearance;
components_size_y = pcb_size_y - 2 * components_clearance;
components_size_z = components_size_z_above + components_size_z_below + pcb_size_z;

battery_size = [19.92,21.18,5.62 - pcb_size_z];
battery_offset_y = 2.16;
battery_offset_x = 0.77;
battery_pos = [pcb_size_x - battery_offset_x - battery_size[0],battery_offset_y, pcb_size_z];


button_size_z = 5.10 - pcb_size_z;
button_size_x = 6;
button_size_y = 6;
button_offset_x = 8.26; // from bottom of pcb to top edge of button
button_offsets_y = [8.21, 18.19, 28.23];
button_pad_z = 5; // ensure we have a hole for the button.
 
led_offset_x = 17.78; // edge of led
led_offsets_y = [7.54, 17.50, 27.84]; // edge of leds (not center)
led_size_z = 9; // total highe of cylinder and cap hemisphere
led_diameter = 5.88; // diameter of the lip on the bottom of the led.
led_radius = led_diameter / 2;


pcb();

case_thick = 1;


%minkowski() {
  $fn = 50;
  translate([-case_thick, -case_thick, -1 * ( case_thick + components_size_z_below ) ])
    cube([
      pcb_size_x + case_thick * 2, 
      pcb_size_y + case_thick * 2, 
      pcb_size_z + components_size_z_below + components_size_z_above + case_thick * 2]);
  sphere(r=1);
}


module pcb() {
  union() {

    // pcb
    color("green") cube([pcb_size_x, pcb_size_y, pcb_size_z]);

    Components();

    // battery pack
    color("lightblue") translate(battery_pos) cube(battery_size);

    // leds
    led_pos_x = pcb_size_x - led_offset_x + led_radius; // center of led
    color("red")   LED([led_pos_x,pcb_size_y - led_offsets_y[0] + led_radius,pcb_size_z]);
    color("blue")  LED([led_pos_x,pcb_size_y - led_offsets_y[1] + led_radius,pcb_size_z]);
    color("green") LED([led_pos_x,pcb_size_y - led_offsets_y[2] + led_radius,pcb_size_z]);


    button_pos_x = pcb_size_x - button_offset_x;
    Button([button_pos_x,pcb_size_y - button_offsets_y[0] ,pcb_size_z]);
    Button([button_pos_x,pcb_size_y - button_offsets_y[1] ,pcb_size_z]);
    Button([button_pos_x,pcb_size_y - button_offsets_y[2] ,pcb_size_z]);
  }
}

module Components() {

  // buffer to make room for components, and soldered leads.
  union() {
    translate([components_clearance, components_clearance, -1 * components_size_z_below ])
      cube([
        components_size_x,
        components_size_y,
        components_size_z
      ]);

    clear1_size_y = 24;
    clear1_offset_y = 2.5;
    translate([0, pcb_size_y - clear1_offset_y - clear1_size_y, - components_size_z_below])
      cube([components_clearance, clear1_size_y, components_size_z_below]);

    clear2_size_x = 6.9;
    clear2_offset_x = 1.85;
    translate([pcb_size_x - clear2_offset_x - clear2_size_x, pcb_size_y - components_clearance, - components_size_z_below])
      cube([clear2_size_x, components_clearance, components_size_z_below]);
  }
}

module LED(position) {

  $fn = 20;

  cylinder_height = led_size_z - led_radius;
  translate(position)
    union() {
      cylinder(r=led_radius, h=cylinder_height);
      translate([0,0,cylinder_height]) sphere(r=led_radius);
    }
}

module Button(position) {
  color("black")
    translate(position)
      cube([button_size_x, button_size_y, button_size_z]);
  translate([position[0], position[1], position[2] + button_size_z])
    cube([button_size_x, button_size_y, button_pad_z]);
}
