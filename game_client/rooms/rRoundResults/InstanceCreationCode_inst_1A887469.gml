text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	with objController {
		global.state.round_reports = [];
		progress_round()
		do_map_damages() 
	}
	with objOnline {
		//send data to others
		send_compound(MESSAGE.PROGRESS_ROUND,[{type:"struct",content:global.state},{type:"struct",content:global.map}])	
	}
	create(0,0,objMoveCameraDown)
	clickable = false
}

if global.state.role != ROLE.PRESIDENT {
	visible = false
	clickable = false
}