if async_load[? "type"] != network_type_data {
	show_debug_message(	async_load[? "type"])
	exit;
}

var packet = async_load[? "buffer"];
var _name, _msg;
buffer_seek(packet,buffer_seek_start,0)

var message_type = buffer_read(packet,buffer_u8);

switch(message_type) {
	case MESSAGE.ANNOUNCEMENT: //server announcement
		_msg = buffer_read(packet,buffer_string);
		chat_add(string("Server announcement: {0}",_msg))
	break;
	
	case MESSAGE.CONNECT: //user connects
		_name = buffer_read(packet,buffer_string);
		chat_add(string("{0} has connected.",_name))
	break;
	
	case MESSAGE.DISCONNECT: //user disconnects
		_name = buffer_read(packet,buffer_string);
		chat_add(string("{0} has disconnected.",_name))
	break;
	
	case MESSAGE.TIME: //host sends time
		global.state.seconds_remaining = buffer_read(packet,buffer_u32);
	break;
	
	case MESSAGE.MAP: //host sends map data
		var map_data = buffer_read(packet,buffer_string);
		global.map = json_parse(map_data)
	break;
	
	case MESSAGE.STATE: //host sends state data
		var state_data = buffer_read(packet,buffer_string);
		var state_struct = json_parse(state_data);
		global.state.current_round = state_struct.current_round
		global.state.datetime = state_struct.datetime
		global.state.current_phase = state_struct.current_phase
		global.state.time_remaining = state_struct.time_remaining
		global.state.seconds_remaining = state_struct.seconds_remaining
		global.state.state_budget = state_struct.state_budget
		global.state.base_tax = state_struct.base_tax
		global.state.money_spent = state_struct.money_spent
		global.state.disaster = state_struct.disaster
		global.state.disaster_intensity = state_struct.disaster_intensity
		global.state.affected_tiles = state_struct.affected_tiles
		global.state.round_reports = state_struct.round_reports
		global.state.measures_implemented = state_struct.measures_implemented
		global.state.next_disaster = state_struct.next_disaster
		global.state.aid_objectives = state_struct.aid_objectives
	break;
	
	case MESSAGE.END_DISCUSSION:
		with objController end_discussion()
	break;
}