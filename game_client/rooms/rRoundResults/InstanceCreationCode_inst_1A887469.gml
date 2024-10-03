text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { 
		progress_round()
		do_map_damages() 
	}
	create(0,0,objMoveCameraDown)
	clickable = false
}