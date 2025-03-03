if room == rInit {
	global.maps = ds_map_create()
	room_goto(rMap01) //init map data
}

global.mouse_depth = 0;

if room == rInGame {
	global.ai_messages = get_ai_messages()	
	if array_length(global.ai_messages) > 0 {
		alarm[0] = game_get_speed(gamespeed_fps)*60 //1 minute until AI chimes in
	}
	open_dialog("Would you like to enable tutorial popups?",function(resp){ if resp == "Yes" global.tutorial_enabled = true })
}