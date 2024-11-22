if !locked and mouse_on and mouse_check_pressed(mb_left) {
	if !selected {
		with objMeasureIcon selected = false
		selected = true
		objMapGUI.selected_measure = measure_id
	} else {
		selected = false
		objMapGUI.selected_measure = -1	
	}
}