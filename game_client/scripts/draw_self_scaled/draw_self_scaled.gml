/// @function		draw_self_scaled(ratio, min, max);
/// @param			{real}		ratio
/// @param			{real}		min
/// @param			{real}		max
/// @requires		xtend
/// @description	Draws the sprite assigned to the running object scaled relative to the size of 
///					the active view camera. Ratio is calculated as a percentage of view width OR
///					height (whichever is greater), with a value of 1 fully covering the view at any 
///					aspect (e.g. for backgrounds). 
///
///					Because this ratio alone may result in sprites smaller or larger than desirable
///					on one axis, a min and max ratio can also be supplied to limit size on the other
///					axis than is calculated for the base ratio (e.g. for HUD elements). If max is set 
///					to 0, clamping will be disabled.
///
///					Also returns the scale multiplier, which can be used to position or scale other
///					elements relative to the drawn sprite. Scale multiplier will also be reflected in 
///					built-in `image_xscale` and `image_yscale` instance variables.
///
/// @example		draw_self_scaled(0.25, 0.15, 0.5);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function draw_self_scaled(_ratio, _min, _max) {
	// Get sprite properties
	var spr_width  = sprite_get_width(sprite_index);
	var spr_height = sprite_get_height(sprite_index);
	
	// Get sprite to window ratio, adjusted for input ratio
	var spr_ratio = max((view_width/spr_width), (view_height/spr_height))*_ratio;
	
	// Clamp ratio to percentage of window size
	if (_max > 0) {
		// Disallow min exceeding max
		_min = min(_min, _max);
		
		// Clamp ratio
		spr_ratio = clamp(
			spr_ratio,
			max((view_width*_min)/spr_width, (view_height*_min)/spr_height),
			min((view_width*_max)/spr_width, (view_height*_max)/spr_height)
		);
	}
	
	// Set sprite scale
	image_xscale = spr_ratio;
	image_yscale = spr_ratio;
	
	// Draw sprite
	draw_self();
	
	
	/*
	DEBUG
	*/
	
	// Draw hints, if enabled
	if (xtend.debug.hints_enabled) {
		// Get current drawing properties
		var fnt = draw_get_font();
		var halign = draw_get_halign();
		var valign = draw_get_valign();
		var color = draw_get_color();
		var alpha = draw_get_alpha();
	
		// Get opposite hints color
		var color_alt = make_color_hsv(
			(color_get_hue(xtend.debug.hints_color) + 128) mod 255,
			color_get_saturation(xtend.debug.hints_color),
			color_get_value(xtend.debug.hints_color)
		);
	
		// Set hints drawing properties
		draw_set_font(xtend.debug.font);
		draw_set_alpha(xtend.debug.hints_alpha);
			
		// Get unscaled sprite position
		var spr_xoffset = (sprite_get_xoffset(sprite_index));
		var spr_yoffset = (sprite_get_yoffset(sprite_index));
		var spr_x = (x - spr_xoffset);
		var spr_y = (y - spr_yoffset);
		
		// Set color based on scale state
		if ((spr_width*spr_ratio) > spr_width)
		or ((spr_height*spr_ratio) > spr_height) {
			// Extend
			draw_set_color(xtend.debug.hints_color);
		} else {
			// Crop
			draw_set_color(color_alt);
		}
		
		// Draw unscaled hint box
		draw_rectangle(spr_x, spr_y, spr_x + spr_width, spr_y + spr_height, true);
		draw_line(spr_x + spr_xoffset, spr_y, spr_x + spr_xoffset, spr_y + spr_height);
		draw_line(spr_x, spr_y + spr_yoffset, spr_x + spr_width, spr_y + spr_yoffset);
		
		// Draw bottom hint box label
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		draw_text(
			spr_x + (spr_width*0.5), spr_y + spr_height + string_height(" "), 
			string(round((spr_height*spr_ratio) - spr_height)) + "px"
		);
	
		// Draw right hint box label
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_text(
			spr_x + spr_width + string_width(" "), spr_y + (spr_height*0.5), 
			string(round((spr_width*spr_ratio) - spr_width)) + "px"
		);
		
		// Get scaled sprite position
		spr_xoffset = (sprite_get_xoffset(sprite_index)*spr_ratio);
		spr_yoffset = (sprite_get_yoffset(sprite_index)*spr_ratio);
		spr_x = (x - spr_xoffset);
		spr_y = (y - spr_yoffset);
		
		// Get scaled sprite dimensions
		spr_width *= spr_ratio;
		spr_height *= spr_ratio;
		
		// Draw scaled hint box
		draw_rectangle(spr_x, spr_y, spr_x + spr_width, spr_y + spr_height, true);
		draw_line(spr_x + spr_xoffset, spr_y, spr_x + spr_xoffset, spr_y + spr_height);
		draw_line(spr_x, spr_y + spr_yoffset, spr_x + spr_width, spr_y + spr_yoffset);
		
		// Reset drawing properties
		draw_set_font(fnt);
		draw_set_halign(halign);
		draw_set_valign(valign);
		draw_set_color(color);
		draw_set_alpha(alpha);
	}
	
	// Draw debug stats, if enabled
	if (xtend.debug.stats_enabled) {
		// Get current font properties
		var fnt		= draw_get_font();
		var color	= draw_get_color();
		var halign	= draw_get_halign();
		var valign	= draw_get_valign();
	
		// Set debug font
		draw_set_font(xtend.debug.font);
		draw_set_color(xtend.debug.stats_color);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		
		// Get unscaled sprite properties
		var spr_width  = sprite_get_width(sprite_index);
		var spr_height = sprite_get_height(sprite_index);
		
		// Get scaled sprite properties
		var spr_x = x - (sprite_get_xoffset(sprite_index)*spr_ratio);
		var spr_y = y - (sprite_get_yoffset(sprite_index)*spr_ratio);
	
		// Draw scaling stats
		draw_text(
			spr_x + font_get_size(xtend.debug.font), spr_y + font_get_size(xtend.debug.font),
			"[Scaling]" +
			"\nBase: " + string(spr_width) + "x" + string(spr_height) +
			"\nSprite: " + string(round(spr_width*spr_ratio)) + "x" + string(round(spr_height*spr_ratio))
		);
	
		// Reset font properties
		draw_set_font(fnt);
		draw_set_color(color);
		draw_set_halign(halign);
		draw_set_valign(valign);
	}
	
	// Return sprite scale
	return spr_ratio;
}