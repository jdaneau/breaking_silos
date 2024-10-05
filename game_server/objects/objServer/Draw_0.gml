var all_players = ds_list_size(socketlist);

draw_set_color(c_white)
draw_set_halign(fa_center)
draw_text(room_width/2,room_height/3,"Connected Players: " + string(all_players))

var _socket;
for(var _i=0; _i<ds_list_size(socketlist); _i++) {
	_socket = ds_list_find_value(socketlist,_i)
	if ds_map_exists(players,_socket) {
		draw_text(room_width/2,room_height/2+(32*_i),ds_map_find_value(players,_socket))
	}
}
