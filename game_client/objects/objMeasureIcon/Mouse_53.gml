if !locked and mouse_on and mouse_check_button_pressed(mb_left) and global.state.role = ROLE.PRESIDENT {
	if !selected {
		with objMeasureIcon selected = false
		selected = true
		objMapGUI.selected_measure = measure_id
	} else {
		selected = false
		objMapGUI.selected_measure = noone	
	}
}