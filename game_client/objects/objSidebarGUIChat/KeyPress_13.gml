if !instance_exists(objDialogWindow) {
	open_dialog_question("Chat Message: ", function(msg) { 
		send_string(MESSAGE.CHAT,msg)
	})
}