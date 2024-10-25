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

var socket_type = network_socket_ws;
var server_ip = "127.0.0.1";

if os_browser == browser_not_a_browser {
	socket_type = network_socket_tcp
	server_ip = "127.0.0.1";
}

ping = 0
port = 20002
socket = network_create_socket(socket_type)

network_connect_async(socket,server_ip,port)
client_buffer = buffer_create(1024,buffer_fixed,1)

connected = false
lobby_id = ""
