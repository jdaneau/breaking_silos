if !instance_exists(objDialogWindow) {
	open_dialog_question("Chat Message: ", function(msg) { chat_add(msg) })
}