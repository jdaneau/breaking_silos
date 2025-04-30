if global.mouse_depth >= depth {
	if coords_in(mouse_x,mouse_y,x,y-h-tab_h,x+sprite_width,y) {
		mouse_on = true	
	} else mouse_on = false
} else mouse_on = false

if mouse_on {
	if (sprite_height - h) > 1 {
		h = lerp(h,sprite_height,0.1)
	} else h = sprite_height
}
else {
	if h > 1 {
		h = lerp(h,0,0.1)
	} else h = 0
}