text = "Return to Title"

on_click = function(on) {
	open_dialog("Are you sure you want to leave the lobby?", function(resp) {
		if resp == "Yes" {
			objOnline.lobby_id = ""
			global.state.player_name = ""
			ds_map_clear(objOnline.players)
			send(MESSAGE.LEAVE_GAME)
			room_goto(rTitle)
		}
	})
}