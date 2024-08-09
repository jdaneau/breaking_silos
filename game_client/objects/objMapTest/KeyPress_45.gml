var i;
var _f = file_text_open_read("map.json");
var _json = file_text_read_string(_f);
file_text_close(_f)
global.map = json_parse(_json)

for(i=0; i<array_length(global.map.land_tiles); i++) {
	var _tile = global.map.land_tiles[i];
	instance_create_depth(_tile.x,_tile.y,2,objMapTile)
}

for(i=0; i<array_length(global.map.river_tiles); i++) {
	var _river = global.map.river_tiles[i];
	instance_create_depth(_river.x,_river.y,1,_river.obj)
}

for(i=0; i<array_length(global.map.hospitals); i++) {
	var _hosp = global.map.hospitals[i];
	instance_create_depth(_hosp.x,_hosp.y,0,objHospital)
}

for(i=0; i<array_length(global.map.airports); i++) {
	var _airp = global.map.airports[i];
	instance_create_depth(_airp.x,_airp.y,0,objAirport)
}


with objMapTile event_user(0)