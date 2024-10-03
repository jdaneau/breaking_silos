text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { start_round() }
	room_goto(rInGame)
}