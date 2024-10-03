text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { progress_round() }
	create(0,0,objMoveCameraDown)
	clickable = false
}