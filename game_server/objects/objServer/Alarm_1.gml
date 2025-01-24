alarm[1] = round(game_get_speed(gamespeed_fps) * 5) //15 seconds

var all_sockets = ds_map_keys_to_array(sockets);
for(var i=0; i<array_length(all_sockets); i++) {
	send_id(all_sockets[i], MESSAGE.CHECK_ONLINE)
	array_push(destroy_sockets, all_sockets[i])
}

alarm[2] = round(game_get_speed(gamespeed_fps) * 2) //8 seconds to get a response