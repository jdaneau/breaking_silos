var type_event = async_load[? "type"];
var socket, sock, cid, did, buffer, message_id, findsocket, name, data, value, lobby_id, playernames;

switch(type_event){
	case network_type_connect:
		socket = async_load[? "socket"]
		ds_map_add(sockets,socket,"")
	break;
	
	case network_type_disconnect:
		socket = async_load[? "socket"]
		lobby_id = sockets[? socket];
		if lobby_id != "" {
			name = ds_map_find_value(lobbies[? lobby_id].players,socket)
			send_to_others(socket,MESSAGE.DISCONNECT,buffer_string,name)
			ds_map_delete(lobbies[? lobby_id].players, socket)
			if ds_map_size(lobbies[? lobby_id].players) == 0 {
				ds_map_delete(lobbies, lobby_id)	
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
				show_debug_message(name)
				show_debug_message(data)
				do lobby_id = random_id() until !ds_map_exists(lobbies,lobby_id)
				ds_map_add(lobbies,lobby_id,{
					name : name,
					settings : data,
					players : ds_map_create(),
					state : "lobby"
				})
				sockets[? socket] = lobby_id
				ds_map_add(lobbies[? lobby_id].players, socket, "player1")
				send(socket,MESSAGE.CREATE_GAME,buffer_string,lobby_id)
			break;
			
			case MESSAGE.JOIN_GAME:
				lobby_id = buffer_read(buffer,buffer_string)
				var n_players = num_players(lobby_id);
				if ds_map_exists(lobbies, lobby_id) and n_players < max_per_lobby {
					name = string("player{0}",n_players+1)
					sockets[? socket] = lobby_id
					ds_map_add(lobbies[? lobby_id].players, socket, name)
					var playerlist = ds_map_values_to_array(lobbies[? lobby_id].players);
					send_array(socket,MESSAGE.JOIN_GAME,"string",playerlist)
					send_to_others(socket,MESSAGE.JOIN_GAME,buffer_string,name)
				}
				else send(socket,MESSAGE.JOIN_GAME,buffer_u8,0) // signifies unsuccessful connection
			break;
			
			case MESSAGE.LEAVE_GAME:
				lobby_id = sockets[? socket];
				if lobby_id != "" {
					name = ds_map_find_value(lobbies[? lobby_id].players,socket)
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
				if ds_map_exists(lobies[? lobby_id].players,name) {
					send(socket,MESSAGE.SET_NAME,buffer_bool,false) //error, name already exists
					break;
				}
				ds_map_replace(lobbies[? lobby_id].players,socket,name)
				playernames = ds_map_values_to_array(lobbies[? lobby_id].players)
				send(socket,MESSAGE.SET_NAME,buffer_bool,true)
				send_array(socket,MESSAGE.GET_PLAYERS,"string",playernames,true,true)
			break;
			
			case MESSAGE.GET_NAME:
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players,socket)
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
				playernames = ds_map_values_to_array(lobbies[? lobby_id].players)
				send_array(socket,MESSAGE.GET_PLAYERS,"string",playernames)
			break;
			
			default:
				show_debug_message(string("unknown message ID: {0}",message_id))
			break;
		}
	break;
}