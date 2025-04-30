if show {
	
	draw_roundrect_ext(x-(sprite_width*2),y-dropdown_height,x+(sprite_width*3),y+64,24,24,false)
	
	var _y = y - button_height;
	for(var i=0; i<(array_length(buttons)+1); i++) {
		var _x = x - sprite_width;
		if i mod 2 == 1 { _x = x + sprite_width }
		var subimg = 0;
		var text_color = global.colors.light_blue;
		if coords_in(mouse_x,mouse_y,_x-32,_y,_x+sprite_width+32,_y+button_height) {
			subimg = 1
			text_color = global.colors.light_blue_50
			if mouse_check_pressed(mb_left) {
				with objMapGUI reset_info_layers()
				if i == 0 { 
					selected = -1	
				} else {
					selected = i-1;
					buttons[selected].on_click(true)
				}	
				show = false
			}
		}
		var spr = sprDropdownNone;
		if i > 0 spr = buttons[i-1].sprite
		draw_sprite(spr,subimg,_x,_y)
		draw_set_font(font)
		draw_set_color(text_color)
		draw_set_halign(fa_center)
		draw_set_valign(fa_top)
		if i == 0 {
			draw_text(_x+(sprite_width/2),_y+75,"None")
		}
		else {
			draw_text_ext(_x+(sprite_width/2),_y+75,buttons[i-1].text,16,sprite_width+32)
		}
		if i mod 2 == 1 { _y -= button_height }
	}
}

draw_set_color(c_white)