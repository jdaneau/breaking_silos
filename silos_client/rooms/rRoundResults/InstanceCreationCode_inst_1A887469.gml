text = "Next"
font = fSidebar
color = c_black

on_click = function(on) {
	if global.state.current_round < objOnline.lobby_settings.n_rounds {
		with objController {
			global.state.round_reports = []
			progress_round()
			do_map_damages() 
		}
		with objOnline {
			//send data to others
			send_state()
			send_updated_map()
			send(MESSAGE.PROGRESS_ROUND)
		}
		create(0,0,objMoveCameraDown)
		clickable = false
	} else {
		with objController {
			finish_all_projects()
		}
		with objOnline {
			send_state()
			send_updated_map()
			send(MESSAGE.GAME_END)
		}
		global.state.affected_tiles = []
		room_goto(rGameResults)
		global.state.current_room = rGameResults
	}
}

if global.state.role != ROLE.PRESIDENT {
	visible = false
	clickable = false
}