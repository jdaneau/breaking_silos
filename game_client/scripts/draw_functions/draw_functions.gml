/// @function draw_gui_border(x1, y1, x2 ,y2, [col1], [col2])
/// @description Draws a rectangular border on the screen, intended to surround GUI elements.
function draw_gui_border(_x1,_y1,_x2,_y2,_col1=c_black,_col2=c_white){
	draw_set_color(_col1)
	draw_rectangle(_x1,_y1,_x2,_y2,true)
	draw_set_color(_col2)
	draw_rectangle(_x1-1,_y1-1,_x2+1,_y2+1,true)
	draw_set_color(_col1)
	draw_rectangle(_x1-2,_y1-2,_x2+2,_y2+2,true)
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