var type_event = async_load[? "type"];
var socket, sock, cid, did, buffer, message_id, findsocket, name, data, value;

switch(type_event){
	case network_type_connect:
		socket = async_load[? "socket"]
		ds_list_add(socketlist,socket)
	break;
	
	case network_type_disconnect:
		socket = async_load[? "socket"]
		findsocket = ds_list_find_index(socketlist,socket)
		if findsocket >= 0
			ds_list_delete(socketlist,findsocket)
		name = ds_map_find_value(players,socket)
		if name == -1 name = "UNDEFINED"
		ds_map_delete(players,socket)
		
		send_to_all(MESSAGE.DISCONNECT,buffer_string,name)
	break;
	
	case network_type_data:
		buffer = async_load[? "buffer"]
		socket = async_load[? "id"]
		buffer_seek(buffer,buffer_seek_start,0)
		message_id = buffer_read(buffer,buffer_u8)
		switch(message_id) {
			case MESSAGE.CONNECT: //user connects and sends name
				name = buffer_read(buffer,buffer_string)
				ds_map_add(players,socket,name)
				send_to_all(MESSAGE.CONNECT,buffer_string,name)
			break;
			
			case MESSAGE.TIME:
				value = buffer_read(buffer,buffer_u32);
				send_to_others(MESSAGE.TIME,buffer_u32,value,socket)
			break;
			
			case MESSAGE.MAP:
			case MESSAGE.STATE:
				data = buffer_read(buffer,buffer_string)
				send_to_others(MESSAGE.MAP,buffer_string,data,socket)
			break;
			
			case MESSAGE.END_DISCUSSION:
				send_id_to_others(MESSAGE.END_DISCUSSION,socket)
			break;
		}
	break;
}