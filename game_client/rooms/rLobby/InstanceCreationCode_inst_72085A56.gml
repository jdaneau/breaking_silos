text = "Return to Title"

on_click = function(on) {
	open_dialog("Are you sure you want to leave the lobby?", function(resp) {
		if resp == "Yes" {
			objOnline.lobby_id = ""
			global.state.player_name = ""
			global.state.role = ROLE.NONE
			objOnline.got_map = false
			objOnline.got_state = false
			ds_map_clear(objOnline.players)
			send(MESSAGE.LEAVE_GAME)
			room_goto(rTitle)
		}
	})
}