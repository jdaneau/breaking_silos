if hover {
	show = !show
	with objMeasureIcon selected = false
	objMapGUI.selected_measure = -1
}
else if show and !coords_in(mouse_x,mouse_y,x-(sprite_width*2),y-dropdown_height,x+(sprite_width*3),y){
	show = false
}