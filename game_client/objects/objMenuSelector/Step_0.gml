var box_size = sprite_height;

if mouse_check_pressed(mb_left) {
	//left arrow
	if coords_in(mouse_x,mouse_y,x,y,x+box_size,y+box_size) {
		index--
		if index < 0 {
			index = array_length(options) - 1	
		}
	}
	
	//right arrow
	if coords_in(mouse_x,mouse_y,x+sprite_width-box_size,y,x+sprite_width,y+box_size) {
		index++
		if index >= array_length(options) {
			index = 0	
		}
	}
}

selected = options[index]