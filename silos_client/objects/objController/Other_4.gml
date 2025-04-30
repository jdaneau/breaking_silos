if room == rInit {
	global.maps = ds_map_create()
	room_goto(rMap01) //init map data
}

global.mouse_depth = 0;

if room == rInGame {
	global.starting_budget = global.state.state_budget
	if global.state.current_round == 1 instance_create_depth(0,0,-200,objGUIIntro)
}

if room == rLobby {
	open_dialog_info("Successfully Connected to Lobby\n\nNOTE: If you leave the current tab while in-game, there is a risk of being disconnected. Try to keep the current tab active at all times!")	
}