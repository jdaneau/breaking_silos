if timeout {
	if timeout_attempts < 3 {
		timeout_attempts++
		alarm[0]=1
	}
	else {
		show_message("Server connection timeout! Restarting game.")
		game_restart()
	}
}