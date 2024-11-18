if hover and mouse_check_pressed(mb_left)  {
	show = !show
	with objMeasureIcon selected = false
	objMapGUI.selected_measure = -1
}
else if show{
	if coords_in(mouse_x,mouse_y,x,y-dropdown_height,x+sprite_width,y){
		var i = (y - mouse_y) div (floor(sprite_height * (2/3)));
		with objMapGUI reset_info_layers()
		if i == 0 { 
			selected = -1	
		} else {
			selected = i-1;
			buttons[selected].on_click(true)
		}
		
	}
	show = false
}