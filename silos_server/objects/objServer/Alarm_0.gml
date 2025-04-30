//destroy any lobbies that had no responsive players
for(var i=0; i<array_length(destroy_lobbies); i++) {
	var lobby_id = destroy_lobbies[i];
	if !ds_map_exists(lobbies, lobby_id) {
		continue	
	}
	if !variable_struct_exists(lobbies[? lobby_id], "players") { 
		ds_map_delete(lobbies, lobby_id)
		continue
	}
	var players = lobbies[? lobby_id].players;
	var player_sockets = ds_map_keys_to_array(players);
	show_debug_message(string("No respone from lobby {0}, deleting lobby. Players: {1}",lobby_id,ds_map_values_to_array(players)))
	var n_removed = 0;
	for(var p=0; p<array_length(player_sockets); p++) {
		if ds_map_exists(sockets, player_sockets[p]) {
			ds_map_delete(sockets, player_sockets[p])	
			n_removed++
		}
	}
	show_debug_message(string("Removed {0} players from the socket list.",n_removed))
	ds_map_destroy(players)
	ds_map_delete(lobbies, lobby_id)
}
destroy_lobbies = []