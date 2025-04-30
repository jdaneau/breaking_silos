//destroy any sockets that had no response within 8 seconds
var n_removed = 0;
var check_lobbies = [];
for(var i=0; i<array_length(destroy_sockets); i++) {
	var sock = destroy_sockets[i];
	if ds_map_exists(sockets, sock) {
		if ds_map_exists(ping_attempts, sock) {
			ping_attempts[? sock] += 1
			if ping_attempts[? sock] >= 3 {
				array_push(check_lobbies,{lobby_id:sockets[? sock],socket:sock})
				ds_map_delete(sockets, sock)	
				ds_map_delete(ping_attempts, sock)
				n_removed++
			}
		} else ping_attempts[? sock] = 1
	}
}
if n_removed > 0 { 
	var lobby_ids = ds_map_keys_to_array(lobbies);
	for(var i=0; i<array_length(check_lobbies); i++) {
		var struct = check_lobbies[i];
		if ds_map_exists(lobbies, struct.lobby_id) {
			var lobby = lobbies[? struct.lobby_id];
			var socket = struct.socket;
			if ds_map_exists(lobby.players, socket) {
				var name = ds_map_find_value(lobby.players,socket).name;
				var role = ds_map_find_value(lobby.players,socket).role;
				ds_map_delete(lobby.players, socket)
				send_to_lobby(struct.lobby_id,MESSAGE.DISCONNECT,buffer_string,name)
				if ds_map_size(lobby.players) == 0 {
					ds_map_destroy(lobby.players)
					ds_map_delete(lobbies, lobby_ids[i])	
				}
				else {
					if role == "President" and lobby.state == "started" {
						var new_president = array_first(ds_map_keys_to_array(lobby.players));
						var new_president_name = lobby.players[? new_president].name;
						send(new_president, MESSAGE.JOIN_ROLE,buffer_string,"President")
						send_to_all(new_president, MESSAGE.ANNOUNCEMENT, buffer_string, string("{0} has replaced {1} as President.",new_president_name,name))
					}
					var lobby_players = ds_map_values_to_array(lobby.players);
					var lobby_socket  = array_first(ds_map_keys_to_array(lobby.players));
					send_array(lobby_socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
				}
			}
		}
	}
	show_debug_message(string("Removed {0} players from the socket list.",n_removed))
}
destroy_sockets = []