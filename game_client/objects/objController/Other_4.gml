if room == rInit {
	global.maps = ds_map_create()
	room_goto(rMap01) //init map data
}

global.mouse_depth = 0;

if room == rInGame {
	global.starting_budget = global.state.state_budget
	if global.state.current_round == 1 instance_create_depth(0,0,-200,objGUIIntro)
}