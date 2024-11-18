var light = make_color_hsv(0,0,220);

if show {
	var button_height = sprite_height * (2/3);
	for(var i=0; i<(array_length(buttons)+1); i++) {
		draw_set_color(c_ltgray)
		if coords_in(mouse_x,mouse_y,x,y-((i+1)*button_height),x+sprite_width,y-(i*button_height)) {
			draw_set_color(light)	
		}
		draw_button(x,y-((i+1)*button_height),x+sprite_width,y-(i*button_height),true)
		draw_set_color(c_black)
		draw_set_font(fSidebar)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		if i == 0 {
			draw_text(x+(sprite_width/2),y-button_height/2,"None")
		}
		else {
			draw_text_ext(x+(sprite_width/2),y-((i+1)*button_height)+(button_height/2),buttons[i-1].text,16,sprite_width-4)
		}
	}
}

draw_set_color(c_white)