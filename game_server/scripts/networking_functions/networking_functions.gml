function send_to_all(message_id,type,content) {
	for(var i=0; i<ds_map_size(objServer.players); i++) {
		var sock = ds_list_find_value(objServer.socketlist,i);
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		buffer_write(objServer.server_buffer,type,content)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_to_others(message_id,type,content,sender) {
	for(var i=0; i<ds_map_size(objServer.players); i++) {
		var sock = ds_list_find_value(objServer.socketlist,i);
		if sock != sender {
			buffer_seek(objServer.server_buffer,buffer_seek_start,0)
			buffer_write(objServer.server_buffer,buffer_u8,message_id)
			buffer_write(objServer.server_buffer,type,content)
			network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
		}
	}
}

function send_id_to_all(message_id) {
	for(var i=0; i<ds_map_size(objServer.players); i++) {
		var sock = ds_list_find_value(objServer.socketlist,i);
		buffer_seek(objServer.server_buffer,buffer_seek_start,0)
		buffer_write(objServer.server_buffer,buffer_u8,message_id)
		network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
	}
}

function send_id_to_others(message_id,sender) {
	for(var i=0; i<ds_map_size(objServer.players); i++) {
		var sock = ds_list_find_value(objServer.socketlist,i);
		if sock != sender {
			buffer_seek(objServer.server_buffer,buffer_seek_start,0)
			buffer_write(objServer.server_buffer,buffer_u8,message_id)
			network_send_packet(sock,objServer.server_buffer,buffer_tell(objServer.server_buffer))
		}
	}
}