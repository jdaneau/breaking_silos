if hover {
	draw_set_font(fDescription)
	var w = 480;
	var sep = 16;
	var h = string_height_ext(text,sep,w);
	draw_color_rectangle(mouse_x+8,mouse_y,mouse_x+8+512+8+2,mouse_y+h+8+2,c_black,false)
	draw_color_rectangle(mouse_x+9,mouse_y+1,mouse_x+8+512+8+1,mouse_y+h+8+1,c_white,false)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	draw_text_ext(mouse_x+8+4,mouse_y+4,text,sep,w)
	draw_set_color(c_white)
}