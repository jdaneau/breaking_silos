text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { start_round() }
	with objOnline {
		//send data to others
		send_state()
		send_updated_map()
		send(MESSAGE.NEW_ROUND)
	}
	room_goto(rInGame)
}

if global.state.role != ROLE.PRESIDENT {
	visible = false
	clickable = false
}