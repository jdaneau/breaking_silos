text = "Return to Title"

on_click = function(on) {
	open_dialog("Are you sure you want to leave the lobby?", function(resp) {
		if resp == "Yes" {
			send(MESSAGE.LEAVE_GAME)
			game_restart()
		}
	})
}