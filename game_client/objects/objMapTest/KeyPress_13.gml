//generate map matrices for encoding within the game

struct = {
	width : room_width,
	height: room_height,
	land_tiles : [],
	river_tiles : [],
	hospitals : [],
	airports : [],
	land_grid : array_init_2d(room_width/64,room_height/64,0),
	river_grid : array_init_2d(room_width/32,room_height/32,0),
	hospital_grid : array_init_2d(room_width/16,room_height/16,0),
	airport_grid : array_init_2d(room_width/16,room_height/16,0)
}

var n,i,j;

//account for land tiles
for (n=0; n<instance_number(objMapTile); ++n;) {
	var _tile = instance_find(objMapTile,n); 
	var _x = _tile.x div 64;
	var _y = _tile.y div 64;
	array_push(struct.land_tiles,{x:_tile.x, y:_tile.y, index:_tile.image_index, metrics:_tile.metrics})
	struct.land_grid[_x,_y] = 1
}

//account for river tiles
for (n=0; n<instance_number(objRiverH); ++n;) {
	var _river = instance_find(objRiverH,n); 
	var _x = _river.x div 32;
	var _y = _river.y div 32;
	array_push(struct.river_tiles,{x:_river.x, y:_river.y, obj:_river.object_index, spr:_river.sprite_index})
	struct.river_grid[_x,_y] = 1
}


//account for hospitals and airports
for (n=0; n<instance_number(objHospital); ++n;) {
	var _hosp = instance_find(objHospital,n); 
	var _x = _hosp.x div 16;
	var _y = _hosp.y div 16;
	array_push(struct.hospitals,{x:_hosp.x, y:_hosp.y})
	struct.hospital_grid[_x,_y] = 1
}
for (n=0; n<instance_number(objAirport); ++n;) {
	var _airp = instance_find(objAirport,n); 
	var _x = _airp.x div 16;
	var _y = _airp.y div 16;
	array_push(struct.airports,{x:_airp.x, y:_airp.y})
	struct.airport_grid[_x,_y] = 1
}

var _json_data = json_stringify(struct);
var _f = file_text_open_write("map.json");
file_text_write_string(_f,_json_data)
file_text_close(_f)
