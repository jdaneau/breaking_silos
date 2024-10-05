function end_discussion(){
	with objSidebarGUIChat chat_add("Discussion over! The president will now decide which measures to implement.")
	 
	global.state.current_phase = "decision"
	global.state.time_remaining = game_get_speed(gamespeed_fps) * 300
	global.state.seconds_remaining = 300
	
	if global.state.role == ROLE.PRESIDENT {
		if instance_exists(objOnline) {
			send(MESSAGE.END_DISCUSSION)
		}
		with objGUIButton {
			text = "Finalize Decision"
			on_click = function(on) {
				dialog_mode = "question"
				dialog_status = "end_round"
				dialog = show_question_async("Are you sure you want to finalize your decision?\nThis will end the current round.")
			}
		}
		with objGUIMesaures {
			measures = ds_map_keys_to_array(global.measures)
			event_user(0)
		}
		with objMapGUI {
			placing = true
			layer_caption = "Click on the measures to place them on the map.\nLeft click = add, Right click = remove"
		}
	} else {
		// other players	
	}
}