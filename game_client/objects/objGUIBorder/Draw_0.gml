if fill {
	draw_set_color(fill_color)
	draw_roundrect_ext(x,y,x+sprite_width, y+sprite_height, 24, 24, false)
	draw_set_color(c_white)
}

draw_gui_border(x,y,x+sprite_width,y+sprite_height,line_color)