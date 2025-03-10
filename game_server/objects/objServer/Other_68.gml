var type_event = async_load[? "type"];
var socket, sock, cid, did, buffer, message_id, findsocket, name, data, msg, value, lobby_id, playernames, role, lobby_players, lobby_sockets;

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
					if role == "President" and lobby.state == "started" {
						var new_president = array_first(ds_map_keys_to_array(lobby.players));
						var new_president_name = lobby.players[? new_president].name;
						lobby.players[? new_president].role = "President"
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
		
		if !ds_map_exists(sockets,socket) {
			exit;
		}
		
		buffer_seek(buffer,buffer_seek_start,0)
		message_id = buffer_read(buffer,buffer_u8)
		switch(message_id) {
			case MESSAGE.PING:
				if ds_map_exists(sockets, socket) {
					send_id(socket,MESSAGE.PING)
				}
			break;
			
			case MESSAGE.CHECK_ONLINE:
				if array_contains(destroy_sockets,socket) {
					array_delete(destroy_sockets,array_get_index(destroy_sockets,socket),1)	
				}
				lobby_id = sockets[? socket]
				if array_contains(destroy_lobbies,lobby_id) {
					array_delete(destroy_lobbies,array_get_index(destroy_lobbies,lobby_id),1)
				}
			break;
			
			case MESSAGE.TIME:
			case MESSAGE.BUDGET:
				value = buffer_read(buffer,buffer_u32)
				send_to_others(socket,message_id,buffer_u32,value)
			break;
			
			case MESSAGE.STATE:
			case MESSAGE.PLACE_MEASURE:
			case MESSAGE.REMOVE_MEASURE:
			case MESSAGE.MAP_CHANGE:
				data = buffer_read(buffer,buffer_string)
				send_to_others(socket,message_id,buffer_string,data)
			break;
			
			case MESSAGE.END_ROUND:
			case MESSAGE.PROGRESS_ROUND:
			case MESSAGE.NEW_ROUND:
				send_id_to_others(socket,message_id)
			break;
			
			case MESSAGE.REQUEST_MAP:
			case MESSAGE.REQUEST_STATE:
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
				lobby_sockets = ds_map_keys_to_array(lobbies[? lobby_id].players)
				var president_socket;
				for(var i=0; i<array_length(lobby_sockets); i++) {
					if ds_map_find_value(lobbies[? lobby_id].players, lobby_sockets[i]).role == "President" {
						president_socket = lobby_sockets[i]
						break;
					}
				}
				send(president_socket,message_id,buffer_string,name)
			break;
			
			case MESSAGE.MAP:
				data = buffer_read(buffer,buffer_string)
				var struct = json_parse(data)
				var target_player = struct.target_player;
				lobby_id = sockets[? socket]
				lobby_sockets = ds_map_keys_to_array(lobbies[? lobby_id].players)
				var target_socket;
				for(var i=0; i<array_length(lobby_sockets); i++) {
					if ds_map_find_value(lobbies[? lobby_id].players, lobby_sockets[i]).name == target_player {
						target_socket = lobby_sockets[i]
						break;
					}
				}
				send(target_socket,MESSAGE.MAP_CHANGE,buffer_string,data)
			break;
			
			case MESSAGE.GAME_END:
				send_id_to_others(socket,message_id)
				if message_id == MESSAGE.GAME_END {
					lobby_id = sockets[? socket]
					lobbies[? lobby_id].state = "finished"
				}
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
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
				send_compound(socket,MESSAGE.MAP_PING,[{type:"string",content:name},{type:"string",content:data}],true,true)
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
				if n_players > 0 and n_players < max_per_lobby {
					var valid_name = false;
					while !valid_name {
						name = string("player{0}",n_players+1)
						lobby_players = ds_map_values_to_array(lobbies[? lobby_id].players);
						var found = false;
						for(var i=0; i<array_length(lobby_players); i++) {
							if lobby_players[i].name == name { found = true }	
						}
						if found { n_players++; continue }
						valid_name=true
					}
					sockets[? socket] = lobby_id
					ds_map_add(lobbies[? lobby_id].players, socket, {name:name,role:""})
					var _players = ds_map_values_to_array(lobbies[? lobby_id].players);
					send_compound(socket,MESSAGE.JOIN_GAME,[
						{type:"string", content:lobby_id},
						{type:"string", content:lobbies[? lobby_id].state},
						{type:"struct", content:lobbies[? lobby_id].settings}
					])
					send_to_others(socket,MESSAGE.JOIN_GAME,buffer_string,name)
					send_array(socket,MESSAGE.GET_PLAYERS,"struct",_players)
				}
				else send(socket,MESSAGE.JOIN_GAME,buffer_string,"") // signifies unsuccessful connection
			break;
			
			case MESSAGE.LEAVE_GAME:
				lobby_id = sockets[? socket];
				if lobby_id != "" {
					var lobby = lobbies[? lobby_id];
					name = ds_map_find_value(lobby.players,socket).name
					role = ds_map_find_value(lobby.players,socket).role
					send_to_others(socket,MESSAGE.LEAVE_GAME,buffer_string,name)
					ds_map_delete(lobby.players, socket)
					if ds_map_size(lobby.players) == 0 {
						ds_map_destroy(lobby.players)
						ds_map_delete(lobbies, lobby_id)	
					}
					else {
						if role == "President" and lobby.state == "started" {
							var new_president = array_first(ds_map_keys_to_array(lobby.players));
							var new_president_name = lobby.players[? new_president].name;
							lobby.players[? new_president].role = "President"
							send(new_president, MESSAGE.JOIN_ROLE,buffer_string,"President")
							send_to_all(new_president, MESSAGE.ANNOUNCEMENT, buffer_string, string("{0} has replaced {1} as President.",new_president_name,name))
						}
						var lobby_socket = array_first(ds_map_keys_to_array(lobby.players));
						lobby_players = ds_map_values_to_array(lobby.players)
						send_array(lobby_socket,MESSAGE.GET_PLAYERS,"struct",lobby_players,true,true)
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
					
					//send a ping to all lobby players and if we get no response from anyone, delete the lobby
					var player_sockets = ds_map_keys_to_array(_lobby.players);
					for(var p=0; p<array_length(player_sockets); p++) {
						send_id(player_sockets[p],MESSAGE.CHECK_ONLINE)
					}
					if !array_contains(destroy_lobbies,key) array_push(destroy_lobbies,key)
				}
				send_array(socket,MESSAGE.GET_LOBBIES,"struct",lobby_list)
				alarm[0] = round(game_get_speed(gamespeed_fps) * 10) //10 second limit on response, if none then destroy lobby
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
					lobbies[? lobby_id].state = "started"
				} else send(socket,MESSAGE.START_GAME,buffer_string,"") //no president, don't start game
			break;
			
			case MESSAGE.LOBBY_INFO:
				lobby_id = sockets[? socket]
				send(socket, MESSAGE.LOBBY_INFO, buffer_string, json_stringify(lobbies[? lobby_id].settings))
			break;
			
			case MESSAGE.HOTJOIN:
				lobby_id = sockets[? socket]
				name = ds_map_find_value(lobbies[? lobby_id].players, socket).name
				lobby_sockets = ds_map_keys_to_array(lobbies[? lobby_id].players)
				var president_socket;
				for(var i=0; i<array_length(lobby_sockets); i++) {
					if ds_map_find_value(lobbies[? lobby_id].players, lobby_sockets[i]).role == "President" {
						president_socket = lobby_sockets[i]
						break;
					}
				}
				send(president_socket,MESSAGE.HOTJOIN_DATA,buffer_string,name)
			break;
			
			case MESSAGE.HOTJOIN_DATA:
				var room_name = buffer_read(buffer, buffer_string);
				name = buffer_read(buffer, buffer_string)
				lobby_id = sockets[? socket]
				lobby_sockets = ds_map_keys_to_array(lobbies[? lobby_id].players)
				var find_socket;
				for(var i=0; i<array_length(lobby_sockets); i++) {
					if ds_map_find_value(lobbies[? lobby_id].players, lobby_sockets[i]).name == name {
						find_socket = lobby_sockets[i]
						break;
					}
				}
				send(find_socket,MESSAGE.HOTJOIN,buffer_string,room_name)
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