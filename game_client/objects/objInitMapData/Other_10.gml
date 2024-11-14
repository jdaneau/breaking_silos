//generate map matrices for encoding within the game

var struct = {
	width : room_width,
	height: room_height,
	land_tiles : [],
	foreign_tiles : [],
	river_tiles : [],
	hospitals : [],
	airports : [],
	land_grid : array_init_2d(room_width/64,room_height/64,0),
	river_grid : array_init_2d(room_width/64,room_height/64,0),
	river_flow_grid : array_init_2d(room_width/64,room_height/64,""),
	hospital_grid : array_init_2d(room_width/64,room_height/64,0),
	airport_grid : array_init_2d(room_width/64,room_height/64,0),
	buildings_grid : array_init_2d(room_width/64,room_height/64,0),
	starting_agriculture : 0,
	hospitals_repaired: 0,
	airports_repaired: 0,
	crops_planted: 0,
	deaths: 0,
	lives_saved: 0,
	money_spent: 0,
	measures_implemented: 0
};

var n,i,j;

//account for land tiles
for (n=0; n<instance_number(objMapTile); ++n;) {
	var _tile = instance_find(objMapTile,n); 
	var _x = _tile.x div 64;
	var _y = _tile.y div 64;
	array_push(struct.land_tiles,{
		x:_tile.x, y:_tile.y, index:_tile.image_index, metrics:_tile.metrics, 
		measures:[], in_progress:[], implemented:[], evacuated_population:[], dammed:false})
	struct.land_grid[_x,_y] = 1
	struct.buildings_grid[_x,_y] = 1
	if _tile.metrics.agriculture > 0 { struct.starting_agriculture += 1 }
}
//account for any foreign tiles
for (n=0; n<instance_number(objForeignTile); ++n;) {
	var _tile = instance_find(objForeignTile,n);
	array_push(struct.foreign_tiles,{x:_tile.x,y:_tile.y,index:_tile.image_index})
}

//account for river tiles
for (n=0; n<instance_number(objRiverH); ++n;) {
	var _river = instance_find(objRiverH,n); 
	var _x = _river.x div 64;
	var _y = _river.y div 64;
	array_push(struct.river_tiles,{x:_river.x, y:_river.y, obj:_river.object_index, spr:_river.sprite_index})
	struct.river_grid[_x,_y] = 1
}

//account for river flow direction
for (n=0; n<instance_number(objRiverFlow); n++) {
	var _flow = instance_find(objRiverFlow,n);
	var _x = _flow.x div 64;
	var _y = _flow.y div 64;
	var _dir = "";
	switch(_flow.object_index) {
		case objRiverFlow:
			_dir = "down";
			break;
		case objRiverFlowUp:
			_dir = "up";
			break;
		case objRiverFlowLeft:
			_dir = "left";
			break;
		case objRiverFlowRight:
			_dir = "right";
			break;
	}
	struct.river_flow_grid[_x,_y] = _dir
}


//account for hospitals and airports
for (n=0; n<instance_number(objHospital); ++n;) {
	var _hosp = instance_find(objHospital,n); 
	var _x = _hosp.x div 64;
	var _y = _hosp.y div 64;
	array_push(struct.hospitals,{x:_hosp.x, y:_hosp.y, damaged:false})
	struct.hospital_grid[_x,_y] = 1
}
for (n=0; n<instance_number(objAirport); ++n;) {
	var _airp = instance_find(objAirport,n); 
	var _x = _airp.x div 64;
	var _y = _airp.y div 64;
	array_push(struct.airports,{x:_airp.x, y:_airp.y, damaged:false})
	struct.airport_grid[_x,_y] = 1
}

global.maps[? room] = struct
if room == rMap01 { room_goto(rMap02) }
else if room == rMap02 { room_goto(rMap03) }
else {
	global.map = global.maps[? rMap01]
	room_goto(rTitle)
}