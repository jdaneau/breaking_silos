var p_num;
p_num = parameter_count();

var socket_type = network_socket_tcp;

for (var i = 0; i < p_num; i += 1) {
   p_string[i] = parameter_string(i);
   switch(p_string[i]) {
      case "-nowindow":
         draw_enable_drawevent(false);
      break;
	  case "-socket":
		 var stype = p_string[i+1];
		 if stype == "tcp" socket_type = network_socket_tcp;
		 else if stype == "udp" socket_type = network_socket_udp;
		 else if stype == "ws" socket_type = network_socket_ws;
	  break;
   }
}

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
	END_DISCUSSION = 31,
	END_ROUND = 32,
	PROGRESS_ROUND = 33,
	NEW_ROUND = 34,
	GAME_END = 35
}

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