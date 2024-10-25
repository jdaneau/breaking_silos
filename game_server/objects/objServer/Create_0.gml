enum MESSAGE {
	CONNECT = 1,
	DISCONNECT = 2,
	CREATE_GAME = 3,
	JOIN_GAME = 4,
	LEAVE_GAME = 5,
	ANNOUNCEMENT = 6,
	SET_NAME = 7,
	GET_NAME = 8,
	GET_LOBBIES = 9,
	GET_PLAYERS = 10,
	CHAT = 21,
	TIME = 22,
	MAP = 23,
	STATE = 24,
	END_DISCUSSION = 31,
}

var socket_type = show_question("Use web sockets?") ? network_socket_ws : network_socket_tcp;

port = 20002
max_per_lobby = 8
max_lobbies = 10
max_players = max_per_lobby * max_lobbies

server = network_create_server(socket_type,port,max_players)
server_buffer = buffer_create(1024,buffer_fixed,1)

interval = 5
last_time = 0

lobbies = ds_map_create()
sockets = ds_map_create()