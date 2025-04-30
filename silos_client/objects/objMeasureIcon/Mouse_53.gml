if !locked and mouse_on and mouse_check_pressed(mb_left) {
	if !selected {
		with objMeasureIcon selected = false
		selected = true
		objMapGUI.selected_measure = measure_id
		
		if measure_id == MEASURE.DAM { tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.MEASURE_DAM) }
		if measure_id == MEASURE.EVACUATE { tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.MEASURE_EVACUATE) }
		if measure_id == MEASURE.RELOCATION { tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.MEASURE_RELOCATE) }
		
	} else {
		selected = false
		objMapGUI.selected_measure = -1	
	}
}