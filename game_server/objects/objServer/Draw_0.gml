var all_players = ds_map_size(sockets);

draw_set_color(c_white)
draw_set_halign(fa_center)
draw_text(room_width/2,room_height/3,"Connected Players: " + string(all_players))

var text_y = room_height / 3 + 64

var _lobbies = ds_map_values_to_array(lobbies);
for (var i=0; i<array_length(_lobbies); i++) {
	var lobby = _lobbies[i];
	draw_text(room_width/2,text_y,string("Lobby: {0}, Players: {1}",lobby.name,ds_map_size(lobby.players)))
	text_y += 32
}
