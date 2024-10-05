if async_load[? "type"] != network_type_data {
	show_debug_message(	async_load[? "type"])
	exit;
}

var packet = async_load[? "buffer"];
var _name, _msg;
buffer_seek(packet,buffer_seek_start,0)

var message_type = buffer_read(packet,buffer_u8);

switch(message_type) {
	case 1: //server announcement
		_msg = buffer_read(packet,buffer_string);
		ds_list_add(global.chat,string("Server announcement: {0}",_msg))
	break;
	
	case 4: //user connects
		_name = buffer_read(packet,buffer_string);
		ds_list_add(global.chat,string("{0} has connected.",_name))
	break;
	
	case 5: //user disconnects
		_name = buffer_read(packet,buffer_string);
		ds_list_add(global.chat,string("{0} has disconnected.",_name))
	break;
}