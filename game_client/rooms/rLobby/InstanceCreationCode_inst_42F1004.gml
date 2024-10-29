text = "Change name"

on_click = function(on) {
	open_dialog_question("New name:", function(resp){
		if ds_map_exists(objOnline.players,resp) {
			open_dialog_info("Name is already being used by another player.")	
		}
		else if string_length(resp) < 1 {
			open_dialog_info("Invalid name: must be at least 1 character long.")	
		}
		else if string_starts_with(resp,"player") {
			open_dialog_info("Invalid name. Try something else!")	
		}
		else {
			send_string(MESSAGE.SET_NAME,resp)
		}
	})
}