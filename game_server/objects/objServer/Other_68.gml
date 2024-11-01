var type_event = async_load[? "type"];
var socket, sock, cid, did, buffer, message_id, findsocket, name, data, msg, value, lobby_id, playernames, role, lobby_players;

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
				role = ds_map_find_value(lobby.players,socket).role
				sockets[? socket] = lobby_ids[i]
				send_to_others(socket,MESSAGE.DISCONNECT,buffer_string,name)
				ds_map_delete(lobby.players, socket)
				if ds_map_size(lobby.players) == 0 {
					ds_map_destroy(lobby.players)
					ds_map_delete(lobbies, lobby_ids[i])	
				}
				else {
					if role == "President" {
						var new_president = array_first(ds_map_keys_to_array(lobby.players));
						var new_president_name = lobby.players[? new_president].name;
						send(new_president, MESSAGE.JOIN_ROLE,buffer_string,"President")
						send_to_all(new_president, MESSAGE.ANNOUNCEMENT, buffer_string, string("{0} has replaced {1} as President.",new_president_name,name))
					}
					var lobby_socket = array_first(ds_map_keys_to_array(lobby.players));
					lobby_players = ds_map_values_to_array(lobby.players)
					send_array(lobby_socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
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
			case MESSAGE.PING:
				send_id(socket,MESSAGE.PING)
			break;
			
			case MESSAGE.TIME:
			case MESSAGE.BUDGET:
				value = buffer_read(buffer,buffer_u32)
				send_to_others(socket,message_id,buffer_u32,value)
			break;
			
			case MESSAGE.STATE:
			case MESSAGE.MAP:
			case MESSAGE.PLACE_MEASURE:
			case MESSAGE.REMOVE_MEASURE:
			case MESSAGE.END_ROUND:
			case MESSAGE.PROGRESS_ROUND:
			case MESSAGE.NEW_ROUND:
				data = buffer_read(buffer,buffer_string)
				send_to_others(socket,message_id,buffer_string,data)
			break;
			
			case MESSAGE.END_DISCUSSION:
				send_id_to_others(socket,message_id)
			break;
			
			case MESSAGE.ANNOUNCEMENT:
				msg = buffer_read(buffer,buffer_string);
				lobby_id = sockets[? socket]
				send_to_all(socket,MESSAGE.ANNOUNCEMENT,buffer_string,msg)
			break;
			
			case MESSAGE.CHAT:
				msg = buffer_read(buffer,buffer_string);
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
				send_compound(socket, MESSAGE.CHAT, [{type:"string",content:name},{type:"string",content:msg}], true,true)
			break;
			
			case MESSAGE.MAP_PING:
				data = buffer_read(buffer,buffer_string)
				send_to_all(socket,MESSAGE.MAP_PING,buffer_string,data)
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
					var _players = ds_map_values_to_array(lobbies[? lobby_id].players);
					send(socket,MESSAGE.JOIN_GAME,buffer_string,lobby_id)
					send_to_others(socket,MESSAGE.JOIN_GAME,buffer_string,name)
					send_array(socket,MESSAGE.GET_PLAYERS,"struct",_players)
				}
				else send(socket,MESSAGE.JOIN_GAME,buffer_string,"") // signifies unsuccessful connection
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
					send(socket,MESSAGE.GET_NAME,buffer_string,"") //error, name already exists
					break;
				}
				var old_name = ds_map_find_value(lobbies[? lobby_id].players,socket).name;
				role = ds_map_find_value(lobbies[? lobby_id].players,socket).role
				ds_map_replace(lobbies[? lobby_id].players,socket,{name:name,role:role})
				lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players)
				send(socket,MESSAGE.GET_NAME,buffer_string,name)
				send_compound(socket, MESSAGE.SET_NAME, [{type:"string",content:old_name},{type:"string",content:name}],true,true)
				send_array(socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
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
				lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
				send_array(socket,MESSAGE.GET_PLAYERS,"struct",lobby_players)
			break;
			
			case MESSAGE.JOIN_ROLE:
				role = buffer_read(buffer,buffer_string)
				lobby_id = sockets[? socket]
				lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players)
				var role_occupied = false;
				for(var i=0; i<array_length(lobby_players); i++) {
					if lobby_players[i].role == role { role_occupied = true }
				}
				if !role_occupied {
					name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
					ds_map_replace(lobbies[? lobby_id].players, socket, {name:name,role:role})
					lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
					send_array(socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
					send(socket,MESSAGE.JOIN_ROLE,buffer_string,role)
				}
			break;
			
			case MESSAGE.LEAVE_ROLE:
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
				ds_map_replace(lobbies[? lobby_id].players, socket, {name:name, role:""})
				lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
				send_array(socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
				send_id(socket,MESSAGE.LEAVE_ROLE)
			break;
			
			case MESSAGE.START_GAME:
				lobby_id = sockets[? socket]
				lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
				var found_president = array_find_index(lobby_players,function(p){ return p.role == "President" });
				if found_president >= 0 {
					send_to_all(socket, MESSAGE.START_GAME, buffer_string, json_stringify(lobbies[? lobby_id].settings))
					lobbies[? lobby_id].state = "ingame"
				} else send(socket,MESSAGE.START_GAME,buffer_string,"") //no president, don't start game
			break;
			
			case MESSAGE.LOBBY_INFO:
				lobby_id = sockets[? socket]
				send(socket, MESSAGE.LOBBY_INFO, buffer_string, json_stringify(lobbies[? lobby_id].settings))
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