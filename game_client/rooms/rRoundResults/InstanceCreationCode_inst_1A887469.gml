text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController {
		global.state.round_reports = [];
		progress_round()
		do_map_damages() 
	}
	create(0,0,objMoveCameraDown)
	clickable = false
}