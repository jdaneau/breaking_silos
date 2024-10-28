var type_event = async_load[? "type"];
var socket, sock, cid, did, buffer, message_id, findsocket, name, data, value, lobby_id, playernames, role;

try {

switch(type_event){
	case network_type_connect:
		socket = async_load[? "socket"]
		ds_map_add(sockets,socket,"")
	break;
	
	case network_type_disconnect:
		socket = async_load[? "socket"]
		var lobby_ids = ds_map_keys_to_array(lobbies);
		for(var i=0; i<array_length(lobby_ids); i++) {
			var lobby = lobbies[? lobby_ids[i]];
			if ds_map_exists(lobby.players, socket) {
				name = ds_map_find_value(lobby.players,socket).name
				sockets[? socket] = lobby_ids[i]
				send_to_others(socket,MESSAGE.DISCONNECT,buffer_string,name)
				ds_map_delete(lobby.players, socket)
				if ds_map_size(lobby.players) == 0 {
					ds_map_destroy(lobby.players)
					ds_map_delete(lobbies, lobby_ids[i])	
				}
			}
		}
		ds_map_delete(sockets, socket)
	break;
	
	case network_type_data:
		buffer = async_load[? "buffer"]
		socket = async_load[? "id"]
		buffer_seek(buffer,buffer_seek_start,0)
		message_id = buffer_read(buffer,buffer_u8)
		switch(message_id) {
			case MESSAGE.TIME:
				value = buffer_read(buffer,buffer_u32);
				send_to_others(socket,MESSAGE.TIME,buffer_u32,value)
			break;
			
			case MESSAGE.MAP:
			case MESSAGE.STATE:
				data = buffer_read(buffer,buffer_string)
				send_to_others(socket,message_id,buffer_string,data)
			break;
			
			case MESSAGE.END_DISCUSSION:
				send_id_to_others(socket,MESSAGE.END_DISCUSSION)
			break;
			
			case MESSAGE.CREATE_GAME:
				name = buffer_read(buffer,buffer_string)
				data = receive_struct(buffer)
				do lobby_id = random_id() until !ds_map_exists(lobbies,lobby_id)
				ds_map_add(lobbies,lobby_id,{
					name : name,
					settings : data,
					players : ds_map_create(),
					state : "lobby"
				})
				sockets[? socket] = lobby_id
				ds_map_add(lobbies[? lobby_id].players, socket, {name:"player1",role:""})
				send(socket,MESSAGE.CREATE_GAME,buffer_string,lobby_id)
			break;
			
			case MESSAGE.JOIN_GAME:
				lobby_id = buffer_read(buffer,buffer_string)
				var n_players = num_players(lobby_id);
				if ds_map_exists(lobbies, lobby_id) and n_players < max_per_lobby {
					name = string("player{0}",n_players+1)
					sockets[? socket] = lobby_id
					ds_map_add(lobbies[? lobby_id].players, socket, {name:name,role:""})
					var playerlist = player_names(lobbies[? lobby_id]);
					send_array(socket,MESSAGE.JOIN_GAME,"string",playerlist)
					send_to_others(socket,MESSAGE.JOIN_GAME,buffer_string,name)
				}
				else send(socket,MESSAGE.JOIN_GAME,buffer_u8,0) // signifies unsuccessful connection
			break;
			
			case MESSAGE.LEAVE_GAME:
				lobby_id = sockets[? socket];
				if lobby_id != "" {
					name = ds_map_find_value(lobbies[? lobby_id].players,socket).name
					send_to_others(socket,MESSAGE.LEAVE_GAME,buffer_string,name)
					ds_map_delete(lobbies[? lobby_id].players, socket)
					if ds_map_size(lobbies[? lobby_id].players) == 0 {
						ds_map_delete(lobbies, lobby_id)	
					}
				}
			break;
			
			case MESSAGE.SET_NAME:
				name = buffer_read(buffer,buffer_string)
				lobby_id = sockets[? socket]
				if array_contains(player_names(lobbies[? lobby_id]),name) {
					send(socket,MESSAGE.SET_NAME,buffer_bool,false) //error, name already exists
					break;
				}
				role = lobbies[? lobby_id].players.role
				ds_map_replace(lobbies[? lobby_id].players,socket,{name:name,role:role})
				playernames = player_names(lobbies[? lobby_id])
				send(socket,MESSAGE.SET_NAME,buffer_bool,true)
				send_array(socket,MESSAGE.GET_PLAYERS,"string",playernames,true,true)
			break;
			
			case MESSAGE.GET_NAME:
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players,socket).name
				send(socket, MESSAGE.GET_NAME, buffer_string, name)
			break;
			
			case MESSAGE.GET_LOBBIES:
				var lobby_list = [];
				var keys = ds_map_keys_to_array(lobbies);
				for(var i=0; i<ds_map_size(lobbies); i++) {
					var key = keys[i];
					var _lobby = lobbies[? key];
					var lobby_struct = {
						name : _lobby.name,
						lobby_id : key,
						settings : _lobby.settings,
						players : ds_map_values_to_array(_lobby.players),
						open : (_lobby.state == "lobby")
					};
					array_push(lobby_list, lobby_struct)
				}
				send_array(socket,MESSAGE.GET_LOBBIES,"struct",lobby_list)
			break;
			
			case MESSAGE.GET_PLAYERS:
				lobby_id = sockets[? socket]
				playernames = player_names(lobbies[? lobby_id])
				send_array(socket,MESSAGE.GET_PLAYERS,"string",playernames)
			break;
			
			case MESSAGE.START_GAME:
				lobby_id = sockets[? socket];
				var lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
				var found_president = array_find_index(lobby_players,function(p){ return p.role == "President" });
				if found_president >= 0 {
					send_to_all(socket,MESSAGE.START_GAME,buffer_bool,true)
					lobbies[? lobby_id].state = "ingame"
				} else send(socket,MESSAGE.START_GAME,buffer_bool,false) //no president, don't start game
			break;
			
			default:
				show_debug_message(string("unknown message ID: {0}",message_id))
			break;
		}
	break;
}

}
catch( _exception)
{
    show_debug_message(_exception.message);
    show_debug_message(_exception.longMessage);
    show_debug_message(_exception.script);
    show_debug_message(_exception.stacktrace);
}