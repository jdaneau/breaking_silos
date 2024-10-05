if (last_time + (interval * 1000)) < current_time {
	last_time = current_time

	draw_set_color(c_white)
	draw_set_halign(fa_center)
	var _text = "Connected Players: " + string(ds_list_size(socketlist)) + " => ";
	var _socket;
	for(var _i=0; _i<ds_list_size(socketlist); _i++) {
		_socket = ds_list_find_value(socketlist,_i)
		if ds_map_exists(players,_socket) {
			if _i != 0 _text += ", "
			_text += ds_map_find_value(players,_socket)
		}
	}
	
	show_debug_message(string(last_time) + ": "+ _text)
}