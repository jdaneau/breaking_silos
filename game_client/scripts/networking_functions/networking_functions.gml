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

/// @param {real} message_id : numeric ID of the message to send
/// @param {array} data : array containing structs representing the different messages to send. 
function send_compound(message_id,data) {
	var buffer = objOnline.client_buffer;
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,message_id)
	for(var i=0; i<array_length(data); i++) {
		var type = data[i].type;
		switch type {
			case "string":
				buffer_write(buffer,buffer_string,data[i].content)
				break;
			case "int":
				buffer_write(buffer,buffer_u32,data[i].content)
				break;
			case "float":
				buffer_write(buffer,buffer_f32,data[i].content)
				break;
			case "struct":
				var text = json_stringify(data[i].content);
				buffer_write(buffer,buffer_string,text)
				break;
		}
	}
	network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
}

function receive_struct(buffer) {
	var _json = buffer_read(buffer, buffer_string);
	return json_parse(_json)
}