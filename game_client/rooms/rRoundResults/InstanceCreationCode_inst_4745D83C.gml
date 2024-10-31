text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController { start_round() }
	with objOnline {
		//send data to others
		send_compound(MESSAGE.NEW_ROUND,[{type:"struct",content:global.state},{type:"struct",content:global.map}])	
	}
	room_goto(rInGame)
}

if global.state.role != ROLE.PRESIDENT {
	visible = false
	clickable = false
}