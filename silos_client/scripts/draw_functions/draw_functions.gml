/// @function draw_gui_button(x1, y1, x2, y2, border_color, inside_color, text, [font], [draw_shadow])
/// @description draws a rounded-edge button to the screen with an optional shadow effect
function draw_gui_button(x1,y1,x2,y2,border_color,inside_color,text,font=fMyriadBold14,draw_shadow=true) {
	var w = x2-x1;
	var h = y2-y1;
	if draw_shadow {
		var scale_factor = h / sprite_get_height(sprButtonEdgeBlur);
		scale_factor *= 1.16;
		var shift_amount = 0.08 * h;
		draw_sprite_ext(sprButtonEdgeBlur,0,x1-shift_amount,y1-shift_amount,scale_factor,scale_factor,0,c_white,0.5)
		var _xL = x1 - shift_amount + (sprite_get_width(sprButtonEdgeBlur) * scale_factor);
		var _xR = x2 + shift_amount - (sprite_get_width(sprButtonEdgeBlur) * scale_factor);
		draw_sprite_ext(sprButtonEdgeBlur,1,_xR,y1-shift_amount,scale_factor,scale_factor,0,c_white,0.5)
		var middle_xscale = (_xR - _xL) / sprite_get_width(sprButtonSideBlur);
		draw_sprite_ext(sprButtonSideBlur,0,_xL,y1-shift_amount,middle_xscale,scale_factor,0,c_white,0.5)
	}
	var radius = h/2;
	draw_set_color(border_color)
	draw_circle(x1+radius,y1+radius,radius,false)
	draw_rectangle(x1+radius,y1,x2-radius,y2,false)
	draw_circle(x2-radius,y1+radius,radius,false)
	draw_set_color(inside_color)
	draw_circle(x1+radius,y1+radius,radius-3,false)
	draw_rectangle(x1+radius,y1+3,x2-radius,y2-3,false)
	draw_circle(x2-radius,y1+radius,radius-3,false)
	
	draw_set_font(font)
	var text_height = string_height("|");
	var text_scale = 1;
	if text_height > (h - 24) { text_scale = (h-24) / text_height }
	else if text_height < (h / 4) { text_scale = (h/4) / text_height }
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(border_color)
	draw_text(x1+(w/2),y1+(h/2),text)
	draw_set_color(c_white)
}

/// @function draw_gui_border(x1, y1, x2 ,y2, [color], [outline])
/// @description Draws a round-edged border on the screen, intended to surround GUI elements.
function draw_gui_border(_x1,_y1,_x2,_y2,_color=c_white,_outline=true){
	draw_set_color(_color)
	draw_roundrect_ext(_x1,_y1,_x2,_y2,24,24,_outline)
	draw_roundrect_ext(_x1-1,_y1,_x2-1,_y2,24,24,_outline)
	draw_roundrect_ext(_x1,_y1-1,_x2,_y2-1,24,24,_outline)
	draw_roundrect_ext(_x1+1,_y1,_x2+1,_y2,24,24,_outline)
	draw_roundrect_ext(_x1,_y1+1,_x2,_y2+1,24,24,_outline)
	draw_set_alpha(0.3)
	draw_roundrect_ext(_x1-2,_y1,_x2-2,_y2,24,24,_outline)
	draw_roundrect_ext(_x1,_y1-2,_x2,_y2-2,24,24,_outline)
	draw_roundrect_ext(_x1+2,_y1,_x2+2,_y2,24,24,_outline)
	draw_roundrect_ext(_x1,_y1+2,_x2,_y2+2,24,24,_outline)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

/// @function draw_gui_line(x1, y1, x2 ,y2, [col1], [col2])
/// @description Draws a two-colored line on the screen.
function draw_gui_line(_x1,_y1,_x2,_y2,_col1=c_black,_col2=c_white){
	draw_set_color(_col1)
	draw_line_width(_x1,_y1,_x2,_y2,3)
	draw_set_color(_col2)
	draw_line_width(_x1,_y1,_x2,_y2,1)
	draw_set_color(c_white)
}

/// @function draw_color_rectangle(x1,y1,x2,y2,color,outline)
/// @descrption Draws a uniformly colored rectangle on the screen.
function draw_color_rectangle(x1,y1,x2,y2,color,outline){
	draw_set_color(color)
	draw_rectangle(x1,y1,x2,y2,outline)
	draw_set_color(c_white)
}

/// @function draw_text_outline(x, y, text, text_color, outline_color)
/// @description Draws outlined text on the screen
function draw_text_outline(_text_x,_text_y,_text,_text_color,_outline_color){
	//Draw the text outline
	draw_set_color(_outline_color);
	for (var _xx = -1; _xx <= 1; _xx++)
	{
	    for (var _yy = -1; _yy <= 1; _yy++)
	    {
	        if (_xx != 0 && _yy != 0)
	        {
	            draw_text(_text_x + _xx, _text_y + _yy, _text);
	        }
	    }
	}

	//Draw the text itself
	draw_set_color(_text_color);
	draw_text(_text_x, _text_y, _text);
}

/// @function draw_text_outline_ext_transformed(x, y, text, text_color, outline_color, sep, w, xscale, yscale, angle)
/// @description Draws outlined text on the screen with the functionality of draw_text_ext_transformed
function draw_text_outline_ext_transformed(_text_x,_text_y,_text,_text_color,_outline_color,_sep,_w,_xscale,_yscale,_angle){
	//Draw the text outline
	draw_set_color(_outline_color);
	for (var _xx = -1; _xx <= 1; _xx++)
	{
	    for (var _yy = -1; _yy <= 1; _yy++)
	    {
	        if (_xx != 0 && _yy != 0)
	        {
	            draw_text_ext_transformed(_text_x + _xx, _text_y + _yy, _text,_sep,_w,_xscale,_yscale,_angle);
	        }
	    }
	}

	//Draw the text itself
	draw_set_color(_text_color);
	draw_text_ext_transformed(_text_x, _text_y, _text,_sep,_w,_xscale,_yscale,_angle);
}

/// @function draw_text_multicolor(x, y, text_array)
/// @description draws text to the screen where different segments have different colors. text_array must contain structs with a "text" and "color" field.
function draw_text_multicolor(_x, _y, text_array) {
	for(var i=0; i<array_length(text_array); i++) {
		var struct = text_array[i];
		draw_set_color(struct.color)
		draw_text(_x,_y,struct.text)
		_x += string_width(struct.text)
	}
	draw_set_color(c_white)
}