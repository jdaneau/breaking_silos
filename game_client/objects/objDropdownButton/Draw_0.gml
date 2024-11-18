var light = make_color_hsv(0,0,220);

if show {
	draw_set_color(c_gray)
	draw_button(x,y,x+sprite_width,y+sprite_height,false)
} else {
	if hover {
		draw_set_color(light)
	} else draw_set_color(c_ltgray)
	draw_button(x,y,x+sprite_width,y+sprite_height,true)
}

draw_set_font(fSidebar)
draw_set_color(c_black)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_text_ext(x+(sprite_width/2),y+(sprite_height/2),text,16,sprite_width-4)
draw_set_color(c_white)