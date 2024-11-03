text = "Open Lobby"

on_click = function(on) {
	if objTextInput.text != "" {
		with objController create_lobby()
	}
	else open_dialog_info("You must give the lobby a name!")
}