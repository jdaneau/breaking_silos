if mouse_check(mb_left) {
	if coords_in(mouse_x,mouse_y,x,y,x+sprite_width,y+sprite_height) {
		if mouse_check_pressed(mb_left) mouse_on = true	
		
		if mouse_on {
			var dist = sprite_width / (array_length(ticks)-1);
			for(var i=0; i<array_length(ticks); i++) {
				var lbound = clamp(x+(dist*i)-(dist/2),x,x+sprite_width);
				var rbound = clamp(x+(dist*i)+(dist/2),x,x+sprite_width);
				if coords_in(mouse_x,mouse_y,lbound,y,rbound,y+sprite_height) {
					selected = i	
				}
			}
		}
	}
}
else mouse_on = false

value = ticks[selected]