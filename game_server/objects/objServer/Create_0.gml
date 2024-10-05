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

var socket_type = show_question("Use web sockets?") ? network_socket_ws : network_socket_tcp;

port = 20002
max_players = 8

server = network_create_server(socket_type,port,max_players)
server_buffer = buffer_create(1024,buffer_fixed,1)

socketlist = ds_list_create()
players = ds_map_create() 

interval = 5
last_time = 0