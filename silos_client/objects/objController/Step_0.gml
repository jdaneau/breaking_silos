if global.state.current_phase == "discussion" and global.state.role == ROLE.PRESIDENT {
	if global.state.time_remaining > 0 {
		global.state.time_remaining -= 1
		var seconds = global.state.time_remaining div game_get_speed(gamespeed_fps);
		if seconds < global.state.seconds_remaining {
			global.state.seconds_remaining = seconds
			if instance_exists(objOnline) {
				send_int(MESSAGE.TIME, seconds)
			}
		}
	} else {
		if global.state.current_phase == "discussion" {
			with objMapGUI { selected_measure = noone }
			with objMeasureIcon {
				selected = false
				locked = true
			}
			global.state.current_phase = "decision_timeout"
		}
	}
}
