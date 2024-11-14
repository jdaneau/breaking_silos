text = "Return to Title"
on_click = function(on) {
	send(MESSAGE.LEAVE_GAME)
	game_restart()
}