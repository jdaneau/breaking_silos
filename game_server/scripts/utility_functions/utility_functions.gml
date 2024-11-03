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
	if !ds_map_exists(objServer.lobbies,lobby_id) return -1
	return ds_map_size(objServer.lobbies[? lobby_id].players)	
}

function player_names(lobby) {
	var names = [];
	var structs = ds_map_values_to_array(lobby.players);
	for(var i=0; i<array_length(structs); i++) {
		array_push(names,structs[i].name)	
	}
	return names
}

function string_chunk(str, chunk_size) {
	var index = 1;
	var length = string_length(str);
	var chunks = [];
	while(index <= length) {
		var count = min(chunk_size, length-index+1);
		var chunk = string_copy(str,index,count);
		array_push(chunks,chunk)
	}
	return chunks
}
