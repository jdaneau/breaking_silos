var network_type = async_load[? "type"];

if network_type == network_type_non_blocking_connect {
	if async_load[? "succeeded"] == 0 {
		show_message("Connection to server failed. Retrying...")
		game_restart()
	} else {
		connected = true	
	}
	exit;
}

else if network_type == network_type_disconnect || network_type == network_type_down {
	show_message("Disconnected from server.")
	game_restart()
	exit;
}
else if network_type != network_type_data {
	show_debug_message(	async_load[? "type"])
	exit;
}

var packet = async_load[? "buffer"];
var _name, _msg, struct, tile, result;
buffer_seek(packet,buffer_seek_start,0)

try {

var message_type = buffer_read(packet,buffer_u8);

switch(message_type) {
	case MESSAGE.PING:
		timeout = false
	break;
	
	case MESSAGE.ANNOUNCEMENT: //server announcement
		_msg = buffer_read(packet,buffer_string);
		with objSidebarGUIChat chat_add(_msg)
	break;
	
	case MESSAGE.CHAT:
		_name = buffer_read(packet,buffer_string);
		_msg = buffer_read(packet,buffer_string);
		with objSidebarGUIChat chat_add(string("{0}: {1}",_name,_msg))
	break;
	
	case MESSAGE.DISCONNECT: //user disconnects
		_name = buffer_read(packet,buffer_string);
		with objSidebarGUIChat chat_add(string("{0} has disconnected.",_name))
		if ds_map_exists(players,_name) {
			ds_map_delete(players,_name)	
		}
	break;
	
	case MESSAGE.TIME: //host sends time
		global.state.seconds_remaining = buffer_read(packet,buffer_u32);
	break;
	
	case MESSAGE.BUDGET: //host sends state budget update
		global.state.state_budget = buffer_read(packet,buffer_u32)
	break;
	
	case MESSAGE.MAP_CHANGE:
		if !objOnline.map_initialized {
			switch(objOnline.lobby_settings.landscape_type) {
				case "Island":
					global.map = global.maps[? rMap01]
					objOnline.map_initialized = true
				break;
				case "Coastal":
					global.map = global.maps[? rMap02]
					objOnline.map_initialized = true
				break;
				case "Continental":
					global.map = global.maps[? rMap03]
					objOnline.map_initialized = true
				break;
			}
		}
		result = receive_struct(packet)
		switch(result.type) {
			case "tile":
				tile = tile_from_coords(result.x, result.y)
				tile.metrics = result.metrics
				tile.measures = result.measures
				tile.in_progress = result.in_progress
				tile.implemented = result.implemented
				tile.evacuated_population = result.evacuated_population
				tile.dammed = result.dammed
			break;
			
			case "buildings":
				global.map.buildings_grid = result.buildings_grid
			break;

			case "hospitals":
				global.map.hospital_grid = result.hospital_grid
			break;

			case "airports":
				global.map.airport_grid = result.airport_grid
			break;
			
			case "stats":
				global.map.hospitals_repaired = result.hospitals_repaired
				global.map.airports_repaired = result.airports_repaired
				global.map.crops_planted = result.crops_planted
				global.map.deaths = result.deaths
				global.map.lives_saved = result.lives_saved
				global.map.money_spent = result.money_spent
				global.map.measures_implemented = result.measures_implemented
			break;
		}
		if room == rRoundResults { with objGUIText event_user(0) }
	break;
	
	case MESSAGE.REQUEST_MAP:
		var target_player = buffer_read(packet,buffer_string);
		var changes = get_map_changes();
		for(var i=0; i<array_length(changes); i++) {
			struct = changes[i]
			struct[$ "target_player"] = target_player
			send_struct(MESSAGE.MAP, struct)
		}
	break;
	
	case MESSAGE.END_ROUND:
		room_goto(rRoundResults) 
	break;
	
	case MESSAGE.PROGRESS_ROUND:
		if room == rRoundResults { create(0,0,objMoveCameraDown) }
	break;
	
	case MESSAGE.NEW_ROUND:
		if room == rRoundResults { room_goto(rInGame) }
	break;
	
	case MESSAGE.STATE: //host sends state data
		var state_struct = receive_struct(packet);
		global.state.current_round = state_struct.current_round
		global.state.datetime = state_struct.datetime
		global.state.current_phase = state_struct.current_phase
		global.state.time_remaining = state_struct.time_remaining
		global.state.seconds_remaining = state_struct.seconds_remaining
		global.state.state_budget = state_struct.state_budget
		global.state.base_tax = state_struct.base_tax
		global.state.money_spent = state_struct.money_spent
		global.state.disaster = state_struct.disaster
		global.state.disaster_intensity = state_struct.disaster_intensity
		global.state.affected_tiles = state_struct.affected_tiles
		global.state.round_reports = state_struct.round_reports
		global.state.measures_implemented = state_struct.measures_implemented
		global.state.next_disaster = state_struct.next_disaster
		global.state.aid_objectives = state_struct.aid_objectives
		global.state.n_projects_interrupted = state_struct.n_projects_interrupted
		global.state.n_agriculture_lost = state_struct.n_agriculture_lost
		global.state.n_airports_damaged = state_struct.n_airports_damaged
		global.state.n_hospitals_damaged = state_struct.n_hospitals_damaged
		global.state.n_tiles_damaged = state_struct.n_tiles_damaged
		global.state.starting_population = state_struct.starting_population
		
		if room == rLobby {
			room_goto(rInGame) //start game after receiving game state	
		}
	break;
	
	case MESSAGE.MAP_PING:
		var square = buffer_read(packet, buffer_string);
		var coords = grid_to_coords(square,false);
		instance_create_depth(coords[0],coords[1],-1,objMarker);
	break;
	
	case MESSAGE.END_DISCUSSION:
		with objController end_discussion()
	break;
	
	case MESSAGE.CREATE_GAME:
		lobby_id = buffer_read(packet,buffer_string)
		connected = true
		ds_map_clear(players)
		ds_map_add(players,"player1",ROLE.NONE)
		room_goto(rLobby)
	break;
	
	case MESSAGE.GET_LOBBIES:
		if room == rJoinGame {
			if instance_exists(objLobbyMenu) {
				var n = buffer_read(packet,buffer_u8);
				objLobbyMenu.lobbies = [];
				for(var i=0; i<n; i++) {
					array_push(objLobbyMenu.lobbies, receive_struct(packet))
				}
				objLobbyMenu.scroll = 0
			}
			else send(MESSAGE.GET_LOBBIES)
		}
	break;
	
	case MESSAGE.GET_PLAYERS:
		var n = buffer_read(packet,buffer_u8);
		ds_map_clear(players)
		for(var i=0; i<n; i++) {
			var player = receive_struct(packet);
			ds_map_add(players,player.name,get_role_id(player.role))
		}
		with objGUIText {
			if room == rLobby event_user(0) //update user list
		}
		send(MESSAGE.GET_NAME)
	break;
	
	case MESSAGE.JOIN_GAME:
		//joining a lobby
		if lobby_id == "" {
			lobby_id = buffer_read(packet,buffer_string);
			if lobby_id != "" {
				var landscape_type = buffer_read(packet, buffer_string);
				switch(landscape_type) {
					case "Island":
						global.map = global.maps[? rMap01]
						objOnline.map_initialized = true
					break;
					case "Coastal":
						global.map = global.maps[? rMap02]
						objOnline.map_initialized = true
					break;
					case "Continental":
						global.map = global.maps[? rMap03]
						objOnline.map_initialized = true
					break;
				}
				send(MESSAGE.GET_NAME)
				room_goto(rLobby)
			}
			else {
				open_dialog_info("Unable to join lobby. Refresh and try again!")
			}
		}
		//other player joins 
		else {
			var player_name = buffer_read(packet,buffer_string);
			with objSidebarGUIChat chat_add(string("{0} has joined the game.",player_name))
			ds_map_add(players, player_name, ROLE.NONE)
			with objGUIText {
				if room == rLobby event_user(0) //update user list
			}
		}
	break;
	
	case MESSAGE.LEAVE_GAME:
		var player_name = buffer_read(packet,buffer_string);
		if ds_map_exists(players, player_name) ds_map_delete(players, player_name)
		with objSidebarGUIChat chat_add(string("{0} has left the game.",player_name))
	break;
	
	case MESSAGE.JOIN_ROLE:
		var role = buffer_read(packet,buffer_string);
		global.state.role = get_role_id(role)
		if role == "President" {
			if room == rRoundResults {
				with objGUIButton {
					visible = true
					clickable = true
				}
			}
			if room == rInGame {
				room_restart()
			}
		}
	break;
	
	case MESSAGE.LEAVE_ROLE:
		global.state.role = ROLE.NONE
	break;
	
	case MESSAGE.GET_NAME:
		result = buffer_read(packet, buffer_string);
		if result != "" {
			global.state.player_name = result
		}
		else open_dialog_info("Error setting name! Please try again.")
	break;
	
	case MESSAGE.SET_NAME:
		var old_name = buffer_read(packet, buffer_string);
		var new_name = buffer_read(packet, buffer_string);
		with objSidebarGUIChat chat_add(string("{0} has changed their name to {1}.",old_name,new_name))
	break;
	
	case MESSAGE.START_GAME:
		var lobby_info = buffer_read(packet, buffer_string);
		if lobby_info != "" {
			lobby_settings = json_parse(lobby_info)
			if global.state.role == ROLE.PRESIDENT { 
				var map_room = rMap01
				switch(lobby_settings.landscape_type) {
					case "Island":
						map_room = rMap01
					break;
					case "Coastal":
						map_room = rMap02
					break;
					case "Continental":
						map_room = rMap03
					break;
				}
				global.map = global.maps[? map_room]
				start_round() 
			}
		}
		else open_dialog_info("Erorr starting game! Please try again.")
	break;
	
	case MESSAGE.PLACE_MEASURE:
		struct = receive_struct(packet);
		tile = map_get_tile(struct.x,struct.y);
		array_push(tile.measures, struct.measure)
	break;
	
	case MESSAGE.REMOVE_MEASURE:
		struct = receive_struct(packet);
		tile = map_get_tile(struct.x,struct.y);
		var index = array_index(tile.measures,struct.measure)
		array_delete(tile.measures, index, 1)
	break;
	
	case MESSAGE.GAME_END:
		global.state.affected_tiles = []
		room_goto(rGameResults)
	break;
	
	default:
		show_debug_message(string("unknown message ID: {0}",message_type))
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