text = "Start game"

on_click = function(on) {
	var occupied_roles = ds_map_values_to_array(objOnline.players);
	if array_contains(occupied_roles, ROLE.PRESIDENT) {
		if global.state.role == ROLE.PRESIDENT {
			var n_players = ds_map_size(objOnline.players);
			var dialog_text = "Are you sure you want to start the game?";
			var n_empty = 8 - n_players;
			if n_players < 8 dialog_text += string(" There {0} {1} unfilled role{2}.",n_empty == 1 ? "is" : "are", n_empty, n_empty == 1 ? "" : "s")
			open_dialog(dialog_text,function(resp) {
				if resp == "Yes" { with objOnline send(MESSAGE.START_GAME) }
			})
		}
		else open_dialog_info("Only the president can start the game.")
	}
	else open_dialog_info("You must have a player acting as the president in order to start the game!")
}