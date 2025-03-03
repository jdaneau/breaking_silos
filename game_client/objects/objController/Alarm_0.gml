var message = array_pop(global.ai_messages);
send_string(MESSAGE.ANNOUNCEMENT,message)
if array_length(global.ai_messages) > 0 {
	alarm[0] = irandom_range(game_get_speed(gamespeed_fps)*10,game_get_speed(gamespeed_fps)*20)
}