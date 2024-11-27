/// @description DEMO: Draw demo scenes

/*
BACKGROUND
*/

// Main scene (chosen at random)
if (scene == spr_bg_stage) {
	// Stage scene
	var scale = (view_width/sprite_get_width(spr_bg_stage));
	draw_sprite_ext(spr_bg_stage, 0, 0, view_height, scale, scale, 0, c_white, 1);
	draw_sprite_stretched(spr_bg_curtain, 0, 0, 0, view_width, view_height*0.92);
} else {
	// Classic scene
	draw_sprite_scaled(spr_bg_classic, 0, view_xcenter, view_ycenter, 1, 0, 0);
}

// Pixel scene
draw_sprite(spr_pixel_city, 0, 3840, 2160);


/*
BORDER RULERS
*/

// Get current drawing properties
var fnt = draw_get_font();
var col = draw_get_color();
var halign = draw_get_halign();
var valign = draw_get_valign();

// Draw rulers
draw_set_font(fnt_debug_50);
for (var v = 0; v <= 7; v++) {
	if (view_visible[v]) {
		// Get camera position
		var camera_view_x = camera_get_view_x(view_camera[v]);
		var camera_view_y = camera_get_view_y(view_camera[v]);
		var camera_view_width = camera_get_view_width(view_camera[v]);
		var camera_view_height = camera_get_view_height(view_camera[v]);
		
		// Ruler backgrounds
		draw_set_color(c_white);
		draw_rectangle(
			camera_view_x, 
			camera_view_y,
			camera_view_x + camera_view_width, 
			camera_view_y + 16,
			false
		);
		draw_rectangle(
			camera_view_x, 
			camera_view_y,
			camera_view_x + 16, 
			camera_view_y + camera_view_height,
			false
		);
		
		// Ruler borders
		draw_set_color(c_dkgray);
		draw_line(
			camera_view_x, 
			camera_view_y + 16,
			camera_view_x + camera_view_width, 
			camera_view_y + 16,
		);
		draw_line(
			camera_view_x + 16, 
			camera_view_y,
			camera_view_x + 16, 
			camera_view_y + camera_view_height,
		);
		
		// Ruler marks
		for (var rx = round_to(camera_view_x, 8); rx < (camera_view_x + camera_view_width); rx += 8) {
			if (rx - camera_view_x > 16) {
				if ((abs(rx) mod 64) > 0) {
					// Short marks
					draw_line(
						rx, camera_view_y,
						rx, camera_view_y + 4
					);
					
					// Mouse indicator
					draw_rectangle_color(
						max(mouse_x, camera_view_x + 16), camera_view_y,
						max(mouse_x, camera_view_x + 16) + 1, camera_view_y + 16,
						c_red, c_red, c_red, c_red,
						false
					);
				} else {
					// Grid marks
					draw_line(
						rx, camera_view_y,
						rx, camera_view_y + camera_view_height
					);
				
					// Grid value
					draw_set_halign(fa_left);
					draw_text(rx + 2, camera_view_y + 4, string(rx));
				}
			}
		}
		for (var ry = round_to(camera_view_y, 8); ry < (camera_view_y + camera_view_height); ry += 8) {
			if (ry - camera_view_y > 16) {
				if ((abs(ry) mod 64) != 0) {
					// Short marks
					draw_line(
						camera_view_x, ry,
						camera_view_x + 4, ry
					);
					
					// Mouse indicator
					draw_rectangle_color(
						camera_view_x, max(mouse_y, camera_view_y + 16),
						camera_view_x + 16, max(mouse_y, camera_view_y + 16) + 1, 
						c_red, c_red, c_red, c_red,
						false
					);
				} else {
					// Grid marks
					draw_line(
						camera_view_x, ry, 
						camera_view_x + camera_view_width, ry
					);
				
					// Grid value
					draw_set_halign(fa_right);
					draw_text_transformed(camera_view_x + 4, ry + 2, string(ry), 1, 1, 90);
				}
			}
		}
	}
}

// Reset drawing properties
draw_set_font(fnt);
draw_set_color(col);
draw_set_halign(halign);
draw_set_valign(valign);