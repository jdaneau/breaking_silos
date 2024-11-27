/// @description DEMO: Draw ruler

// Get current drawing properties
var fnt = draw_get_font();
var halign = draw_get_halign();
var valign = draw_get_valign();

// Set drawing properties
draw_set_font(fnt_debug_50);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw line and distance between ruler object pairs
if (!is_even(ruler)) {
	if (instance_exists(global.rulers[ruler - 1])) {
		// Get the instance to pair with from the ruler array
		var inst = global.rulers[ruler - 1];
		
		// Draw line between pair
		draw_line_color(x, y, inst.x, inst.y, c_red, c_red);
		
		// Draw ruler length in pixels
		var len = point_distance(inst.x, inst.y, x, y);
		var dir = point_direction(inst.x, inst.y, x, y);
		draw_text_color(
			inst.x + lengthdir_x(len*0.5, dir), 
			inst.y + lengthdir_y(len*0.5, dir), 
			string(len) + "px",
			c_orange, c_orange, c_orange, c_orange, 1
		);
	}
}

// Draw ruler object
draw_self();

// Reset drawing properties
draw_set_font(fnt);
draw_set_halign(halign);
draw_set_valign(valign);