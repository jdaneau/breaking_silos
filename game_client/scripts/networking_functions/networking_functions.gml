function send(message_id) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}

function send_string(message_id,content) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	buffer_write(buffer,buffer_string,content)
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}

function send_int(message_id,value) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	buffer_write(buffer,buffer_u32,value)
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}

function send_float(message_id,value) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	buffer_write(buffer,buffer_f32,value)
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}

function send_struct(message_id,struct) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	var text = json_stringify(struct);
	buffer_write(buffer,buffer_string,text)
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}