/// old room start event, triggers after intro popup

global.state.current_phase = "discussion"

if global.state.role == ROLE.PRESIDENT {
	global.ai_messages = get_ai_messages()	
	if array_length(global.ai_messages) > 0 {
		alarm[0] = game_get_speed(gamespeed_fps)*60 //1 minute until AI chimes in
	}
	if global.state.current_round == 1 {
		alarm[0] = game_get_speed(gamespeed_fps)*120 //2 minutes until AI chimes in on 1st round
	}
}

if global.state.current_round == 1 {
	open_dialog("Would you like to enable tutorial popups?",function(resp){ 
		if resp == "Yes" {
			global.tutorial_enabled = true 
			array_push(global.tutorial_queue,{x:150,y:96,tutorial_id:TUTORIAL.CHARACTER_INFO})
			array_push(global.tutorial_queue,{x:1056,y:96,tutorial_id:TUTORIAL.BUDGET})
			array_push(global.tutorial_queue,{x:450,y:480,tutorial_id:TUTORIAL.CHAT})
			array_push(global.tutorial_queue,{x:704,y:288,tutorial_id:TUTORIAL.MAP_CONTROLS})
			array_push(global.tutorial_queue,{x:1056,y:528,tutorial_id:TUTORIAL.MAP_LEGEND})
			array_push(global.tutorial_queue,{x:600,y:528,tutorial_id:TUTORIAL.MAP_LAYERS})
			array_push(global.tutorial_queue,{x:1056,y:240,tutorial_id:TUTORIAL.PLACE_MEASURES})
			array_push(global.tutorial_queue,{x:room_width/2-200,y:room_height/2-100,tutorial_id:TUTORIAL.MULTI_HAZARD})
			array_push(global.tutorial_queue,{x:1056,y:96,tutorial_id:TUTORIAL.TIME_LIMIT})
			
			if global.state.role == ROLE.FINANCE array_push(global.tutorial_queue,{x:704,y:528,tutorial_id:TUTORIAL.OPEN_CALCULATOR})
			else array_push(global.tutorial_queue,{x:room_width/2-200,y:room_height/2-100,tutorial_id:TUTORIAL.COLLABORATION})
			
			tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.WELCOME)
		} else global.tutorial_enabled = false
	})	
}