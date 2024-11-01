text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { start_round() }
	with objOnline {
		//send data to others
		send_struct(MESSAGE.STATE,global.state)
		send_chunked_string(MESSAGE.NEW_ROUND, json_stringify(global.map))
	}
	room_goto(rInGame)
}

if global.state.role != ROLE.PRESIDENT {
	visible = false
	clickable = false
}