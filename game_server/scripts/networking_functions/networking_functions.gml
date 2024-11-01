function send(socket,message_id,type,content) {
	buffer_seek(objServer.server_buffer,buffer_seek_start,0)
	buffer_write(objServer.server_buffer,buffer_u8,message_id)
	buffer_write(objServer.server_buffer,type,content)
	network_send_packet(socket,objServer.server_buffer,buffer_tell(objServer.server_buffer))
}

function send_id(socket,message_id) {
	buffer_seek(objServer.server_buffer,buffer_seek_start,0)
	buffer_write(objServer.server_buffer,buffer_u8,message_id)
	network_send_packet(socket,objServer.server_buffer,buffer_tell(objServer.server_buffer))
}

function send_to_all(socket,message_id,type,content) {
	var sockets = get_lobby_sockets(socket);
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		buffer_write(objServer.server_buffer,type,content)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_to_lobby(lobby_id,message_id,type,content) {
	var sockets = ds_map_keys_to_array(lobbies[? lobby_id].players);
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		buffer_write(objServer.server_buffer,type,content)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_to_others(socket,message_id,type,content) {
	var sockets = get_lobby_sockets(socket,false);
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		buffer_write(objServer.server_buffer,type,content)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_id_to_all(socket,message_id) {
	var sockets = get_lobby_sockets(socket);
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_id_to_others(socket,message_id) {
	var sockets = get_lobby_sockets(socket,false);
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function receive_struct(buffer) {
	var _json = buffer_read(buffer, buffer_string);
	return json_parse(_json)
}

function send_array(socket,message_id,datatype,array,to_group=false,inclusive=false) {
	var sockets = [socket];
	if to_group { sockets = get_lobby_sockets(socket,inclusive) }
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		buffer_write(objServer.server_buffer,buffer_u8,array_length(array))
		for(var j=0; j<array_length(array); j++) {
			switch(datatype) {
				case "string":
					buffer_write(objServer.server_buffer,buffer_string,array[j])	
					break;
				case "int":
					buffer_write(objServer.server_buffer,buffer_u32,array[j])	
					break;
				case "float":
					buffer_write(objServer.server_buffer,buffer_f32,array[j])	
					break;
				case "struct":
					var _json = json_stringify(array[j]);
					buffer_write(objServer.server_buffer,buffer_string,_json)	
					break;
			}
			
		}
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_compound(socket,message_id,data,to_group=false,inclusive=false) {
	var sockets = [socket];
	if to_group { sockets = get_lobby_sockets(socket,inclusive) }
	for(var i=0; i<array_length(sockets); i++) {
		var sock = sockets[i];
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		for(var j=0; j<array_length(data); j++) {
			var type = data[j].type;
			switch type {
				case "string":
					buffer_write(objServer.server_buffer,buffer_string,data[j].content)
					break;
				case "int":
					buffer_write(objServer.server_buffer,buffer_u32,data[j].content)
					break;
				case "float":
					buffer_write(objServer.server_buffer,buffer_f32,data[j].content)
					break;
				case "struct":
					var text = json_stringify(data[j].content);
					buffer_write(objServer.server_buffer,buffer_string,text)
					break;
			}
		}
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}