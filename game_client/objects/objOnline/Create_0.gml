enum MESSAGE {
	ANNOUNCEMENT = 1,
	QUERY = 3,
	CONNECT = 4,
	DISCONNECT = 5,
	CHAT = 6,
	TIME = 10,
	MAP = 11,
	STATE = 12,
	END_DISCUSSION = 21,
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

name_msg = get_string_async("Name?","")