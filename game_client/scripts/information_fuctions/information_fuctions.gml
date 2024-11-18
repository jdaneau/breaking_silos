/// @function get_total_population(format)
/// @description Returns the total population of all tiles in the global map
/// @param {string} format : Format to return the population in. "raw":integer number, "thousands":divide total by 1000, "millions":divide total by 1 million
function get_total_population(format="raw",include_evacuated=true) {
	var _pop = 0;
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];	
		_pop += get_population(_tile,include_evacuated)
	}
	if format == "raw"
		return _pop * 1000
	else if format == "thousands"
		return _pop
	else if format == "millions"
		return _pop / 1000
}
function get_population(_tile,include_evacuated=true) {
	var _pop = _tile.metrics.population;
	if (include_evacuated) {
		for(var i=0; i<array_length(_tile.evacuated_population); i++) {
			_pop += _tile.evacuated_population[i].population;
		}
	}
	return _pop
}

/// @function get_total_agriculture()
/// @description returns the total number of agricultural cells on the map
function get_total_agriculture() {
	var n_agriculture = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		if global.map.land_tiles[i].metrics.agriculture > 0 { n_agriculture++ }	
	}	
	return n_agriculture
}

/// @function get_n_damaged_cells()
/// @description returns the total number of cells with damaged buildings
function get_n_damaged_cells() {
	var n_damaged = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tx = global.map.land_tiles[i].x div 64;
		var ty = global.map.land_tiles[i].y div 64;
		if global.map.buildings_grid[tx,ty] == -1 { n_damaged++ }
	}	
	return n_damaged
}
/// @function get_n_damaged_hospitals()
/// @description returns the total number of cells with damaged hospitals
function get_n_damaged_hospitals() {
	var n_damaged = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tx = global.map.land_tiles[i].x div 64;
		var ty = global.map.land_tiles[i].y div 64;
		if global.map.hospital_grid[tx,ty] == -1 { n_damaged++ }
	}	
	return n_damaged
}
/// @function get_n_damaged_airports()
/// @description returns the total number of cells with damaged airports
function get_n_damaged_airports() {
	var n_damaged = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tx = global.map.land_tiles[i].x div 64;
		var ty = global.map.land_tiles[i].y div 64;
		if global.map.airport_grid[tx,ty] == -1 { n_damaged++ }
	}	
	return n_damaged
}

/// @function aid_conditions_met()
/// @description Returns true if the global aid conditions for the last round were met
function aid_conditions_met() {
	return (global.state.aid_objectives.agriculture 
		 && global.state.aid_objectives.airport
		 && global.state.aid_objectives.buildings
		 && global.state.aid_objectives.hospitals)
}

/// @function is_damaged(refStruct, refGrid)
/// @description Returns true if the provided struct is set to damaged in the reference grid array
/// @param {struct} refStruct Tile/hospital/airport struct to check
/// @param {array} refGrid Lookup grid of tiles/hospitals/airports to check for damages
function is_damaged(refStruct, refGrid) {
	var _x = refStruct.x div 64;
	var _y = refStruct.y div 64;
	return (refGrid[_x,_y] == -1)
}

/// @function is_coastal(_x,_y)
/// @description Returns true if the provided coordinates map to a tile on the map that is coastal
function is_coastal(_x,_y) {
	var foreign_grid = array_init_2d(global.map.width div 64, global.map.height div 64, 0);
	for(var i=0; i<array_length(global.map.foreign_tiles); i++) {
		var _tile = global.map.foreign_tiles[i];
		foreign_grid[_tile.x div 64, _tile.y div 64] = 1
	}
	if _x > 0 && global.map.land_grid[_x-1,_y] == 0 && foreign_grid[_x-1,_y] == 0 { return true }
	if _x < (global.map.width div 64) - 1 && global.map.land_grid[_x+1,_y] == 0 && foreign_grid[_x+1,_y] == 0 { return true }
	if _y < (global.map.height div 64) - 1 && global.map.land_grid[_x,_y+1] == 0 && foreign_grid[_x,_y+1] == 0 { return true }
	if _y > 0 && global.map.land_grid[_x,_y-1] == 0 && foreign_grid[_x,_y-1] == 0 { return true }
	return false
}

/// @function coords_to_grid(_i,_j,real_coords=true)
/// @description Converts numeric coordinates to a number-letter grid system (e.g. [1, 2] to B3). Defaults to a 64x64 grid.
/// @param {real} _i : x-coordinate to convert to column number  
/// @param {real} _j : y-coordinate to convert to row number
/// @param {bool} real_coords : Whether input coordinates are absolute (true) or grid-based (false)
function coords_to_grid(_i,_j,real_coords=true) {
	if real_coords {
		_i = _i div 64;
		_j = _j div 64;
	}
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return (string_char_at(_alpha,_i+1) + string(_j+1))
}
/// @function grid_to_coords(_cell,real_coords=true)
/// @description Converts number-letter grid coordinates to numeric coordinates (e.g. B3 to [1,2]). Defaults to a 64x64 grid.
/// @param {string} _cell : string representation of the grid coordinates to be converted
/// @param {bool} real_coords : Whether input coordinates are absolute (true) or grid-based (false)
function grid_to_coords(_cell,real_coords=true) {
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var _i = string_pos(string_char_at(_cell,1),_alpha) - 1; //string indices in GM start at 1, not 0
	var _j;
	if string_length(_cell) == 2 
		_j = real(string_char_at(_cell,2)) - 1;
	else 
		_j = real(string_char_at(_cell,2))*10 + real(string_char_at(_cell,3)) - 1;
	if real_coords return [_i*64,_j*64] else return [_i,_j]
}

/// @function tile_from_coords(_x,_y)
/// @description Retrieves the tile struct with the given coordinates on the map
function tile_from_coords(_x,_y) {
	var n = array_length(global.map.land_tiles);
	for(var i=0; i<n; i++) {
		var _tile = global.map.land_tiles[i];
		if _tile.x div 64 == _x && _tile.y div 64 == _y { return _tile }
	}
	return noone
}
/// @function tile_from_square(_square)
/// @description Retrieves the tile struct with the given label on the map
function tile_from_square(_square) {
	var n = array_length(global.map.land_tiles);
	for(var i=0; i<n; i++) {
		var _tile = global.map.land_tiles[i];
		var check_square = coords_to_grid(_tile.x, _tile.y);
		if check_square == _square { return _tile }
	}
	return noone
}

/// @function get_tiles_in_watershed(watershed_id)
/// @description Returns an array containing all the tile structs that exist in a given watershed on the map
/// @param {real} watershed_id : numeric id of the watershed (starting from 1)
function get_tiles_in_watershed(watershed_id) {
	var _tiles = [];
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		if _tile.metrics.watershed ==  watershed_id {
			array_push(_tiles,_tile);	
		}
	}
	return _tiles
}

/// @function get_downstream_tile(_tile)
/// @description given a cell on the map with a river, return the tile the river flows into (if there is one)
function get_downstream_tile(_tile) {
	var tx = _tile.x div 64; 
	var ty = _tile.y div 64;
	switch (global.map.river_flow_grid[tx,ty]) {
		case "up":
			if global.map.river_flow_grid[tx,ty-1] != "" { return tile_from_coords(tx,ty-1) }
			break;
		case "down":
			if global.map.river_flow_grid[tx,ty+1] != "" { return tile_from_coords(tx,ty+1) }
			break;
		case "left":
			if global.map.river_flow_grid[tx-1,ty] != "" { return tile_from_coords(tx-1,ty) }
			break;
		case "right":
			if global.map.river_flow_grid[tx+1,ty] != "" { return tile_from_coords(tx+1,ty) }
			break;
		default:
			return noone;
	}
	return noone;
}
/// @function get_upstream_tiles(_tile)
/// @description given a cell on the map with a river, return all the tiles that are upstream from it (if applicable)
function get_upstream_tiles(_tile) {
	var tiles_to_check = [_tile];
	var upstream_tiles = [];
	while array_length(tiles_to_check) > 0 {
		var check_tile = array_pop(tiles_to_check);
		var tx = check_tile.x div 64;
		var ty = check_tile.y div 64;
		var up_neighbor = tile_from_coords(tx,ty-1);
		var down_neighbor = tile_from_coords(tx,ty+1);
		var left_neighbor = tile_from_coords(tx-1,ty);
		var right_neighbor = tile_from_coords(tx+1,ty);
		if up_neighbor != noone and get_downstream_tile(up_neighbor) == check_tile {
			array_push(upstream_tiles, up_neighbor)
			array_push(tiles_to_check, up_neighbor)
		}
		if down_neighbor != noone and get_downstream_tile(down_neighbor) == check_tile {
			array_push(upstream_tiles, down_neighbor)
			array_push(tiles_to_check, down_neighbor)
		}
		if left_neighbor != noone and get_downstream_tile(left_neighbor) == check_tile {
			array_push(upstream_tiles, left_neighbor)
			array_push(tiles_to_check, left_neighbor)
		}
		if right_neighbor != noone and get_downstream_tile(right_neighbor) == check_tile {
			array_push(upstream_tiles, right_neighbor)
			array_push(tiles_to_check, right_neighbor)
		}
	}
	return upstream_tiles
}

/// @function is_implementing(tile,_measure)
/// @description Returns true if a given measure is already in the procress of being implemented on the provided cell
/// @param {struct} tile : Struct representing the cell
/// @param {real} _measure : ID of the measure type to check
function is_implementing(tile,_measure) {
	for(var i=0; i<array_length(tile.in_progress); i++) {
		if tile.in_progress[i].measure == _measure { return true }
	}
	return false
}
/// @function get_implementing(tile,_measure)
/// @description Same as is_implementing but returns the matching struct if one is found
function get_implementing(tile,_measure) {
	for(var i=0; i<array_length(tile.in_progress); i++) {
		if tile.in_progress[i].measure == _measure { return tile.in_progress[i] }
	}
	return noone
}

function role_in_game(role) {
	return array_contains(ds_map_values_to_array(objOnline.players),role)	
}

/// @function hospital_availability(tile)
/// @description Calculates the availability of hospitals on a given tile based on its distance to the nearest hospital.
function hospital_availability(tile) {
	var distance_to_hospital = 0;
	var found = false;
	var check_next = [tile];
	var check_next_2 = [];
	var already_checked = [];
	var check_neighbors = function(_tile) {
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;
		if global.map.hospital_grid[tx-1,ty] > 0 { return true }
		if global.map.hospital_grid[tx+1,ty] > 0 { return true }
		if global.map.hospital_grid[tx,ty-1] > 0 { return true }
		if global.map.hospital_grid[tx,ty+1] > 0 { return true }
	}
	while !found {
		while(array_length(check_next) > 0) {
			var tile_to_check = array_pop(check_next);
			array_push(already_checked,coords_to_grid(tile_to_check.x,tile_to_check.y))
			if check_neighbors(tile_to_check) { 
				found = true;
				break; 
			} else {
				var tx = tile_to_check.x div 64;
				var ty = tile_to_check.y div 64;
				var left = tile_from_coords(tx-1, ty); var right = tile_from_coords(tx+1, ty);
				var up = tile_from_coords(tx, ty-1);   var down = tile_from_coords(tx, ty+1);
				if left != noone and not array_contains(already_checked,coords_to_grid(left.x,left.y)) { array_push(check_next_2,left) }
				if right != noone and not array_contains(already_checked,coords_to_grid(right.x,right.y)) { array_push(check_next_2,right) }
				if up != noone and not array_contains(already_checked,coords_to_grid(up.x,up.y)) { array_push(check_next_2,up) }
				if down != noone and not array_contains(already_checked,coords_to_grid(down.x,down.y)) { array_push(check_next_2,down) }
			}
		}
		if !found {
			distance_to_hospital++
			array_copy(check_next,0,check_next_2,0,array_length(check_next_2))
			check_next_2 = []
		}
	}
	return 1 - (distance_to_hospital/5)
}

/// @function agricultural_availability(tile)
/// @description Calculates the "agriculture availability" for a tile, based on the global agriculture supply and distance to the nearest agricultural tile.
function agricultural_availability(tile) {
	var n_agriculture = get_total_agriculture();
	if n_agriculture >= global.map.starting_agriculture { return 1 }
	
	var ratio = n_agriculture / global.map.starting_agriculture;
	
	var distance_to_agriculture = 0;
	var found = false;
	var check_next = [tile];
	var check_next_2 = [];
	var already_checked = [];
	var check_neighbors = function(_tile) {
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;
		var left = tile_from_coords(tx-1, ty); var right = tile_from_coords(tx+1, ty);
		var up = tile_from_coords(tx, ty-1);   var down = tile_from_coords(tx, ty+1);
		if left != noone && left.metrics.agriculture > 0 { return true }
		if right != noone && right.metrics.agriculture > 0 { return true }
		if up != noone && up.metrics.agriculture > 0 { return true }
		if down != noone && down.metrics.agriculture > 0 { return true }
	}
	while !found {
		while(array_length(check_next) > 0) {
			var tile_to_check = array_pop(check_next);
			array_push(already_checked,coords_to_grid(tile_to_check.x,tile_to_check.y))
			if check_neighbors(tile_to_check) { 
				found = true;
				break; 
			} else {
				var tx = tile_to_check.x div 64;
				var ty = tile_to_check.y div 64;
				var left = tile_from_coords(tx-1, ty); var right = tile_from_coords(tx+1, ty);
				var up = tile_from_coords(tx, ty-1);   var down = tile_from_coords(tx, ty+1);
				if left != noone and not array_contains(already_checked,coords_to_grid(left.x,left.y)) { array_push(check_next_2,left) }
				if right != noone and not array_contains(already_checked,coords_to_grid(right.x,right.y)) { array_push(check_next_2,right) }
				if up != noone and not array_contains(already_checked,coords_to_grid(up.x,up.y)) { array_push(check_next_2,up) }
				if down != noone and not array_contains(already_checked,coords_to_grid(down.x,down.y)) { array_push(check_next_2,down) }
			}
		}
		if !found {
			distance_to_agriculture++
			array_copy(check_next,0,check_next_2,0,array_length(check_next_2))
			check_next_2 = []
		}
	}
	if distance_to_agriculture == 0 { distance_to_agriculture = 0.9 } //avoid dividing by 0, give tiles with agriculture a slight boost
	return ratio / distance_to_agriculture
}