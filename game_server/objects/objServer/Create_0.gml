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
	NEW_ROUND = 34
}

var socket_type = show_question("Use web sockets?") ? network_socket_ws : network_socket_tcp;

port = 20002
max_per_lobby = 8
max_lobbies = 10
max_players = max_per_lobby * max_lobbies

server = network_create_server(socket_type,port,max_players)
server_buffer = buffer_create(2048,buffer_fixed,1)

interval = 20 //20 seconds per update
last_time = 0

lobbies = ds_map_create()
sockets = ds_map_create()