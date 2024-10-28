text = "Return to Title"

on_click = function(on) {
	open_dialog("Are you sure you want to leave the lobby?", function(resp) {
		if resp == "Yes" {
			objOnline.connected = false
			objOnline.lobby_id = ""
			objOnline.players = []
			send(MESSAGE.LEAVE_GAME)
			room_goto(rTitle)
		}
	})
}