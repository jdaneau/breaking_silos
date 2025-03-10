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
	MAP_CHANGE = 29,
	REQUEST_MAP = 30,
	REQUEST_STATE = 31,
	END_ROUND = 32,
	PROGRESS_ROUND = 33,
	NEW_ROUND = 34,
	GAME_END = 35,
	CHECK_ONLINE = 40,
	HOTJOIN = 41,
	HOTJOIN_DATA = 42
}

var socket_type = network_socket_ws;
var server_url = "wss://game-server.myriadproject.eu";
port = 443

if os_browser == browser_not_a_browser {
	socket_type = network_socket_tcp
	server_url = "127.0.0.1"
	port = 20002
}

ping = 0
socket = network_create_socket(socket_type)

network_connect_async(socket,server_url,port)
client_buffer = buffer_create(4096,buffer_fixed,1) 

connected = false
lobby_id = ""
lobby_settings = {}
lobby_state = ""
players = ds_map_create()

map_initialized = false

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
timeout_interval = game_fps * 12
timeout_time = game_fps * 3
timeout_attempts = 0
alarm[0] = timeout_interval
timeout = false