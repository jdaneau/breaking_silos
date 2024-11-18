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

function send_chunked_string(message_id,str) {
	var buffer = objOnline.client_buffer;
	var chunks = string_chunk(str,1000);
	var chunk_id = irandom(255);
	var n = array_length(chunks);
	for(var i=0; i<array_length(chunks); i++) {
		buffer_seek(buffer,buffer_seek_start,0)
		buffer_write(buffer,buffer_u8,message_id)
		buffer_write(buffer,buffer_string,json_stringify({id:chunk_id,num:i,total:n,chunk:chunks[i]}))
		network_send_packet(objOnline.socket,buffer,buffer_tell(buffer))
	}
}

function receive_map_chunk(buffer) {
	var chunk_data = json_parse(buffer_read(buffer,buffer_string));
	var chunk_list;
	if ds_map_exists(objOnline.chunks,chunk_data.id) {
		var struct = objOnline.chunks[? chunk_data.id];
		struct.chunks[chunk_data.num] = chunk_data.chunk
		struct.count ++
		if struct.count == struct.total {
			var result_string = "";
			for (var i=0; i<array_length(struct.chunks); i++) {
				result_string = string_concat(result_string,struct.chunks[i])
			}
			ds_map_delete(objOnline.chunks,chunk_data.id)
			return result_string;
		}
	}
	else {
		chunk_list = array_create(chunk_data.total, "")
		chunk_list[chunk_data.num] = chunk_data.chunk
		ds_map_add(objOnline.chunks,chunk_data.id,{total:chunk_data.total, count:1, chunks:chunk_list})
	}
	return ""
}

function send_updated_map() {
	var updates = [];
	array_push(updates, {
		type: "buildings",
		buildings_grid: global.map.buildings_grid
	})
	array_push(updates, {
		type: "hospitals",
		hospital_grid: global.map.hospital_grid
	})
	array_push(updates, {
		type: "airports",
		airport_grid: global.map.airport_grid
	})
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		array_push(updates, {
			type : "tile",
			x : tile.x div 64,
			y : tile.y div 64,
			metrics: tile.metrics,
			measures: tile.measures,
			in_progress: tile.in_progress,
			implemented: tile.implemented,
			evacuated_population: tile.evacuated_population,
			dammed: tile.dammed
		})		
	}
	for(var i=0; i<array_length(updates); i++){
		send_struct(MESSAGE.MAP_CHANGE,updates[i])	
	}
}

function send_state() {
	send_struct(MESSAGE.STATE,{
		current_round : global.state.current_round,
		datetime : global.state.datetime ,
		current_phase : global.state.current_phase ,
		time_remaining : global.state.time_remaining ,
		seconds_remaining : global.state.seconds_remaining,
		state_budget : global.state.state_budget ,
		base_tax : global.state.base_tax,
		money_spent : global.state.money_spent,
		disaster : global.state.disaster,
		disaster_intensity : global.state.disaster_intensity ,
		affected_tiles : global.state.affected_tiles ,
		measures_implemented : global.state.measures_implemented ,
		next_disaster : global.state.next_disaster ,
		aid_objectives : global.state.aid_objectives,
		n_projects_interrupted : global.state.n_projects_interrupted ,
		n_agriculture_lost : global.state.n_agriculture_lost,
		n_airports_damaged : global.state.n_airports_damaged ,
		n_hospitals_damaged : global.state.n_hospitals_damaged,
		n_tiles_damaged : global.state.n_tiles_damaged ,
		starting_population : global.state.starting_population 
	})
	if array_length(global.state.round_reports) > 0 {
		send_struct(MESSAGE.STATE,{ round_reports : global.state.round_reports })
	}
}