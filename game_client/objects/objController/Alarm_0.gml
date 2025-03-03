var message = array_pop(global.ai_messages);
send_string(MESSAGE.ANNOUNCEMENT,message)
if array_length(global.ai_messages) > 0 {
	//20-30 seconds between each AI message
	alarm[0] = irandom_range(game_get_speed(gamespeed_fps)*20,game_get_speed(gamespeed_fps)*30)
}