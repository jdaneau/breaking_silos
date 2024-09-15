/// @function get_total_population(format)
/// @description Returns the total population of all tiles in the global map
/// @param {string} format Format to return the population in. "raw":integer number, "thousands":divide total by 1000, "millions":divide total by 1 million
function get_total_population(format="raw") {
	var _pop = 0;
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];	
		_pop += get_population(_tile)
	}
	if format == "raw"
		return _pop * 1000
	else if format == "thousands"
		return _pop
	else if format == "millions"
		return _pop / 1000
}
function get_population(_tile) {
	var _pop = _tile.metrics.population;
	for(var i=0; i<array_length(_tile.evacuated_population); i++) {
		_pop += _tile.evacuated_population.population;	
	}
	return _pop
}

/// @function coords_to_grid(_i,_j,real_coords=true)
/// @description Converts numeric coordinates to a number-letter grid system (e.g. [1, 2] to B3). Defaults to a 64x64 grid.
/// @param _i {int} x-coordinate to convert to column number  
/// @param _j {int} y-coordinate to convert to row number
/// @param {bool} real_coords Whether input coordinates are absolute (true) or grid-based (false)
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
/// @param _cell {string} string representation of the grid coordinates to be converted
/// @param {bool} real_coords Whether input coordinates are absolute (true) or grid-based (false)
function grid_to_coords(_cell,real_coords=true) {
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var _i = string_pos(string_char_at(_cell,1),_alpha) - 1; //string indices in GM start at 1, not 0
	var _j = real(string_char_at(_cell,2)) - 1
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

/// @function is_coastal(_x,_y)
/// @description Returns true if the provided coordinates map to a tile on the map that is coastal
function is_coastal(_x,_y) {
	if global.map.land_grid[_x-1,_y] == 0 { return true }
	if global.map.land_grid[_x+1,_y] == 0 { return true }
	if global.map.land_grid[_x,_y+1] == 0 { return true }
	if global.map.land_grid[_x,_y-1] == 0 { return true }
	return false
}

/// @function get_tiles_in_watershed(watershed_id)
/// @description Returns an array containing all the tile structs that exist in a given watershed on the map
/// @param watershed_id {int} numeric id of the watershed (starting from 1)
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