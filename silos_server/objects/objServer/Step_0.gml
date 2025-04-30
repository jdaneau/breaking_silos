if (last_time + (interval * 1000)) < current_time {
	last_time = current_time

	draw_set_color(c_white)
	draw_set_halign(fa_center)
	var _text = "Connected Players: " + string(ds_map_size(sockets));
	
	show_debug_message(date_datetime_string(date_current_datetime()) + ": "+ _text)
}