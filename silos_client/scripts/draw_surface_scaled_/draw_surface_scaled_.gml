/// @function		draw_surface_scaled_ext(surf, x, y, ratio, min, max, rot, col, alpha);
/// @param			{surface}	surf
/// @param			{real}		x
/// @param			{real}		y
/// @param			{real}		ratio
/// @param			{real}		min
/// @param			{real}		max
/// @param			{real}		rot
/// @param			{color}		col
/// @param			{real}		alpha
/// @requires		xtend
/// @description	Draws a surface scaled relative to the size of the active view camera. Ratio is 
///					calculated as a percentage of view width OR height (whichever is greater), with 
///					a value of 1 fully covering the view at any aspect (e.g. for backgrounds). 
///
///					Because this ratio alone may result in surfaces smaller or larger than desirable
///					on one axis, a min and max ratio can also be supplied to limit size on the other
///					axis than is calculated for the base ratio (e.g. for HUD elements). If max is set 
///					to 0, clamping will be disabled.
///
///					Also returns the scale multiplier, which can be used to position or scale other
///					elements relative to the drawn surface.
///
///					Note that because surface data is volatile, surfaces are likely to be destroyed
///					if the window is resized. Always check if a surface exists before drawing, and
///					include regeneration code if it does not.
///
/// @example		draw_surface_scaled_ext(my_surf, x, y, 0.25, 0.15, 0.5, 0, c_white, 1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function draw_surface_scaled_ext(_surf, _x, _y, _ratio, _min, _max, _rot, _col, _alpha) {
	// Get surface properties
	var surf_width  = surface_get_width(_surf);
	var surf_height = surface_get_height(_surf);
		
	// Get surface to window ratio, adjusted for input ratio
	var surf_ratio = max((view_width/surf_width), (view_height/surf_height))*_ratio;
	
	// Clamp ratio to percentage of window size
	if (_max > 0) {
		// Disallow min exceeding max
		_min = min(_min, _max);
		
		// Clamp ratio
		surf_ratio = clamp(
			surf_ratio,
			max((view_width*_min)/surf_width, (view_height*_min)/surf_height),
			min((view_width*_max)/surf_width, (view_height*_max)/surf_height)
		);
	}
	
	// Draw surface
	draw_surface_ext(_surf, _x, _y, surf_ratio, surf_ratio, _rot, _col, _alpha);
	
	
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
		
		// Set color based on scale state
		if ((surf_width*surf_ratio) > surf_width)
		or ((surf_height*surf_ratio) > surf_height) {
			// Extend
			draw_set_color(xtend.debug.hints_color);
		} else {
			// Crop
			draw_set_color(color_alt);
		}
		
		// Draw unscaled hint box
		draw_rectangle(_x, _y, _x + surf_width, _y + surf_height, true);
		draw_line(_x, _y, _x + surf_width, _y + surf_height);
		
		// Draw bottom hint box label
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		draw_text(
			_x + (surf_width*0.5), _y + surf_height + string_height(" "), 
			string(round((surf_height*surf_ratio) - surf_height)) + "px"
		);
	
		// Draw right hint box label
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_text(
			_x + surf_width + string_width(" "), _y + (surf_height*0.5), 
			string(round((surf_width*surf_ratio) - surf_width)) + "px"
		);
		
		// Get scaled sprite dimensions
		surf_width *= surf_ratio;
		surf_height *= surf_ratio;
		
		// Draw scaled hint box
		draw_rectangle(_x, _y, _x + surf_width, _y + surf_height, true);
		draw_line(_x, _y, _x + surf_width, _y + surf_height);
		
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
		
		// Get unscaled surface properties
		var surf_width  = surface_get_width(_surf);
		var surf_height = surface_get_height(_surf);
	
		// Draw scaling stats
		draw_text(
			_x + font_get_size(xtend.debug.font), _y + font_get_size(xtend.debug.font),
			"[Scaling]" +
			"\nBase: " + string(surf_width) + "x" + string(surf_height) +
			"\nSurf: " + string(round(surf_width*surf_ratio)) + "x" + string(round(surf_height*surf_ratio))
		);
	
		// Reset font properties
		draw_set_font(fnt);
		draw_set_color(color);
		draw_set_halign(halign);
		draw_set_valign(valign);
	}
	
	// Return surface scale
	return surf_ratio;
}


/// @function		draw_surface_scaled(surf, x, y, ratio, min, max);
/// @param			{surface}	surf
/// @param			{real}		x
/// @param			{real}		y
/// @param			{real}		ratio
/// @param			{real}		min
/// @param			{real}		max
/// @description	Draws a surface scaled relative to the size of the active view camera. Ratio is 
///					calculated as a percentage of view width OR height (whichever is greater), with 
///					a value of 1 fully covering the view at any aspect (e.g. for backgrounds). 
///
///					Because this ratio alone may result in surfaces smaller or larger than desirable
///					on one axis, a min and max ratio can also be supplied to limit size on the other
///					axis than is calculated for the base ratio (e.g. for HUD elements). If max is set 
///					to 0, clamping will be disabled.
///
///					Also returns the scale multiplier, which can be used to position or scale other
///					elements relative to the drawn surface.
///
///					Note that because surface data is volatile, surfaces are likely to be destroyed
///					if the window is resized. Always check if a surface exists before drawing, and
///					include regeneration code if it does not.
///
/// @example		draw_surface_scaled(my_surf, x, y, 0.25, 0.15, 0.5);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function draw_surface_scaled(_surf, _x, _y, _ratio, _min, _max) {
	return draw_surface_scaled_ext(_surf, _x, _y, _ratio, _min, _max, 0, c_white, 1);
}