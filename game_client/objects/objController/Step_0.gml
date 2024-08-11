if (global.state.current_phase == "discussion" or global.state.current_phase == "decision") and global.state.role == ROLE.PRESIDENT {
	if global.state.time_remaining > 0 {
		global.state.time_remaining -= 1
		var seconds = global.state.time_remaining div game_get_speed(gamespeed_fps);
		if seconds < global.state.seconds_remaining {
			global.state.seconds_remaining = seconds
			//TODO: send networking message to other clients to update time
		}
	} else {
		if global.state.current_phase == "discussion" {
			end_discussion()	
		} else if global.state.current_phase == "decision" {
			//end_round()	
		}
	}
}