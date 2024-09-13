//checks for valid placement of measures on the map
function check_map_placement() {
	var n = array_length(global.map.land_tiles);
	var w = global.map.width div 64;
	var h = global.map.height div 64;
	
	//init errors
	var errors = [];
	var make_error = function(errors,_x,_y,_str) {
		var _square = coords_to_grid(_x, _y, false);
		array_push(errors, string("Error at square '{0}': {1}",_square,_str))
	};

	//check all land tiles and their measures
	for(var i=0; i<n; i++) {
		
		var tile = global.map.land_tiles[i];
		var tx = tile.x div 64;
		var ty = tile.y div 64;
		var measures = tile.measures;
		
		var check_implementing = function(_tile,measure_type,error=true) {
			var name = global.measures[? measure_type].name;
			if array_contains(_tile.long_term,measure_type) or array_contains(_tile.medium_term,measure_type) or array_contains(_tile.short_term,measure_type) {
				var completion = "";
				if array_contains(_tile.long_term,measure_type) { completion = "years remaining" }
				else if array_contains(_tile.medium_term,measure_type) { completion = "months remaining" }
				else if array_contains(_tile.short_term,measure_type) { completion = "weeks remaining" }
				if error { make_error(errors,tx,ty,string("Already implementing measure '{0}' on this square ({0}).",name,completion))	}
				return 1;
			}
			else if array_contains(_tile.implemented,measure_type) {
				if error { make_error(errors,tx,ty,string("Measure '{0}' is already implemented on this square.",name)) }
				return 2;
			}
			return 0;
		};
		
		for(var j=0; j<array_length(measures); j++) {
			var _measure = measures[j];
			switch(_measure) {
				case MEASURE.HOSPITAL:
					if global.map.hospital_grid[tx,ty] == 0 {
						make_error(errors,tx,ty,"No hospital exists on this sqaure.")
					}
					else if !array_contains(global.state.affected_tiles,coords_to_grid(tx,ty,false)) and global.map.hospital_grid[tx,ty] == 1 {
						make_error(errors,tx,ty,"Hospital does not need to be rebuilt.")	
					}
				break;
				
				case MEASURE.AIRPORT:
					if global.map.airport_grid[tx,ty] == 0 {
						make_error(errors,tx,ty,"No airport exists on this sqaure.")
					}
					else if !array_contains(global.state.affected_tiles,coords_to_grid(tx,ty,false)) and global.map.airport_grid[tx,ty] == 1 {
						make_error(errors,tx,ty,"Airport does not need to be rebuilt.")	
					}
				break;
				
				case MEASURE.BUILDINGS:
					if !array_contains(global.state.affected_tiles,coords_to_grid(tx,ty,false)) and global.map.buildings_grid[tx,ty] == 1 {
						make_error(errors,tx,ty,"The buildings in this sqaure are not damaged.")	
					}
				break;
				
				case MEASURE.NBS:
					check_implementing(tile,MEASURE.NBS)
					if tile.metrics.agriculture {
						make_error(errors,tx,ty,"Cannot implement NBS on a square with agricultural crops.")	
					}
				break;
				
				case MEASURE.SEAWALL:
					check_implementing(tile,MEASURE.SEAWALL)
					if !is_coastal(tx,ty) {
						make_error(errors,tx,ty,"Cannot build a seawall on a non-coastal square.")
					}
				break;
				
				case MEASURE.NORMAL_CROPS:
				case MEASURE.RESISTANT_CROPS:
					check_implementing(tile,MEASURE.NORMAL_CROPS)
					check_implementing(tile,MEASURE.RESISTANT_CROPS)
					if tile.metrics.agriculture {
						make_error(errors,tx,ty,"Cannot plant crops on a square that already has planted crops on it.")	
					}
					if tile.metrics.population >= 700 {
						make_error(errors,tx,ty,"Cannot plant crops in densely populated squares.")
					}
				break;
				
				case MEASURE.DIKE:
					check_implementing(tile,MEASURE.DIKE)
					if !global.map.river_grid[tx,ty] {
						make_error(errors,tx,ty,"Cannot build a dike on a square without a river.")	
					}
				break;
				
				case MEASURE.RELOCATION:
					check_implementing(tile,MEASURE.RELOCATION)
				break;
				
				case MEASURE.EVACUATE:
					if array_contains(global.state.affected_tiles, coords_to_grid(tx,ty,false)) {
						make_error(errors,tx,ty,"Cannot evacuate population to an affected square.")	
					}
				break;
				
				case MEASURE.DAM:
					if !global.map.river_grid[tx,ty] {
						make_error(errors,tx,ty,"Cannot build a dam on a square without a river.")	
					}
					var watershed_tiles = get_tiles_in_watershed(tile.metrics.watershed);
					var implementing = false;
					var built = false;
					for(var _t = 0; _t < array_length(watershed_tiles); _t++) {
						var _tile = watershed_tiles[_t];
						if array_contains(_tile.measures,MEASURE.DAM) and (_tile.x != tile.x or _tile.y != tile.y) {
							make_error(errors,tx,ty,"You cannot construct two dams in the same watershed.")	
						}
						if check_implementing(_tile,MEASURE.DAM,false) == 1 implementing = true
						if check_implementing(_tile,MEASURE.DAM,false) == 2 built = true
					}
					if implementing {
						make_error(errors,tx,ty,"A dam is currently already being built in this watershed.")	
					}
					else if built {
						make_error(errors,tx,ty,"A dam has already been built in this watershed.")	
					}
				break;
				
				case MEASURE.EWS_CYCLONE:
					check_implementing(tile,MEASURE.EWS_CYCLONE)
					if count_cluster_size(tx, ty, MEASURE.EWS_CYCLONE) < 4 {
						make_error(errors,tx,ty,"Early Warning Systems must be created in clusters of at least 4 squares.")	
					}
				break;
				
				case MEASURE.EWS_FLOOD:
					check_implementing(tile,MEASURE.EWS_FLOOD)
					if count_cluster_size(tx, ty, MEASURE.EWS_FLOOD) < 4 {
						make_error(errors,tx,ty,"Early Warning Systems must be created in clusters of at least 4 squares.")	
					}
				break;
			}
		}
		
	}
	
	return errors;
}

function count_cluster_size(_x, _y, measure_type) {
	var visited = [];
	var to_check = [];
	array_push(to_check, coords_to_grid(_x,_y,false))
	while(array_length(to_check) > 0) {
		var next = array_pop(to_check);
		array_push(visited,next)
		next = grid_to_coords(next,false)
		var left = coords_to_grid(next[0]-1,next[1],false);
		var right = coords_to_grid(next[0]+1,next[1],false);
		var up = coords_to_grid(next[0],next[1]-1,false);
		var down = coords_to_grid(next[0],next[1]+1,false);
		var left_tile = tile_from_square(left);
		var right_tile = tile_from_square(right);
		var up_tile = tile_from_square(up);
		var down_tile = tile_from_square(down);
		if left_tile != noone and !array_contains(visited,left) and array_contains(left_tile.measures, measure_type) {
			array_push(to_check,left)	
		}
		if right_tile != noone and !array_contains(visited,right) and array_contains(right_tile.measures, measure_type) {
			array_push(to_check,right)	
		}
		if up_tile != noone and !array_contains(visited,up) and array_contains(up_tile.measures, measure_type) {
			array_push(to_check,up)	
		}
		if down_tile != noone and !array_contains(visited,down) and array_contains(down_tile.measures, measure_type) {
			array_push(to_check,down)	
		}
	}
	return array_length(visited)
}