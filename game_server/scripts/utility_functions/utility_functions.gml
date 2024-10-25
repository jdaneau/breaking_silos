function random_id() {
	var _id = "";
	repeat(10) _id += string(irandom_range(0,9))
	return _id
}

function get_lobby_sockets(socket,inclusive=true) {
	var lobby_id = objServer.sockets[? socket];
	var player_sockets = [];
	if lobby_id != "" {
		var _keys = ds_map_keys_to_array(objServer.lobbies[? lobby_id].players);
		for(var i=0; i<array_length(_keys); i++) {
			if inclusive || _keys[i] != socket { array_push(player_sockets, _keys[i]) }
		}
	}
	return player_sockets;
}

function num_players(lobby_id) {
	return ds_map_size(objServer.lobbies[? lobby_id].players)	
}