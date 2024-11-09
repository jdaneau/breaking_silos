enum MESSAGE {
	CONNECT = 1,
	DISCONNECT = 2,
	PING = 3,
	CREATE_GAME = 4,
	JOIN_GAME = 5,
	LEAVE_GAME = 6,
	ANNOUNCEMENT = 7,
	SET_NAME = 8,
	GET_NAME = 9,
	GET_LOBBIES = 10,
	GET_PLAYERS = 11,
	START_GAME = 12,
	JOIN_ROLE = 13,
	LEAVE_ROLE = 14,
	LOBBY_INFO = 15,
	CHAT = 21,
	TIME = 22,
	MAP = 23,
	STATE = 24,
	MAP_PING = 25,
	PLACE_MEASURE = 26,
	REMOVE_MEASURE = 27,
	BUDGET = 28,
	END_DISCUSSION = 31,
	END_ROUND = 32,
	PROGRESS_ROUND = 33,
	NEW_ROUND = 34,
	GAME_END = 35
}

var socket_type = network_socket_ws;
var server_ip = "98.71.249.250";

if os_browser == browser_not_a_browser {
	socket_type = network_socket_tcp
}

ping = 0
port = 20002
socket = network_create_socket(socket_type)

network_connect_async(socket,server_ip,port)
client_buffer = buffer_create(2048,buffer_fixed,1) 
chunks = ds_map_create()

connected = false
lobby_id = ""
lobby_settings = {}
players = ds_map_create()

function get_role_player(role_id) {
	var _players = ds_map_keys_to_array(objOnline.players);
	for(var i=0; i<array_length(_players); i++) {
		if objOnline.players[? _players[i]] == role_id {
			return _players[i]	
		}
	}
	return ""
}

game_fps = floor(game_get_speed(gamespeed_fps))
timeout_interval = game_fps * 2
timeout_time = game_fps
alarm[0] = timeout_interval
timeout = false