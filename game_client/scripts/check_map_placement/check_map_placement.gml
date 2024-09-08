//checks for valid placement of measures on the map
function check_map_placement() {
	var n = array_length(global.map.land_tiles);
	var w = global.map.width div 64;
	var h = global.map.height div 64;

	//create a 2d array of all land tiles (for checking clusters)
	var tile_grid = array_init_2d(w, h, "")
	var tile_map = ds_map_create();
	var tile_id = function(_tile) {
		return string(_tile.x div 64) + "," + string(_tile.y div 64)
	}
	for(var i=0; i<n; i++) {
		var tile = global.map.land_tiles[i];
		var _tx = _tile.x div 64;
		var _ty = _tile.y div 64
		var _id = tile_id(tile);
		tile_grid[_tx,_ty] = _id
		ds_map_add(tile_map, _id, tile)
	}
	var get_tile = function(_x,_y) { return tile_map[? tile_grid[string(_x)+","+string(_y)]] };
	var make_cluster_grid = function (measure_type) {
		// Hoshen–Kopelman_algorithm implemented by Tobin Fricke
		// (https://www.ocf.berkeley.edu/~fricke/projects/hoshenkopelman/hoshenkopelman.html)
		var cur_label = 0;
		var label = array_init_2d(w, h, 0);
		var labels = array_create(n, 0);
		for(var i=0; i<n; i++) { labels[i] = i;	}
		var left, above;
		
		var find = function(_x) {
			var _y = _x;
			while labels[_y] != _y {
				_y = labels[_y]
			}
			while labels[_x] != _x {
				var _z = labels[_x];
				labels[_x] = _y
				_x = _z
			}
			return _y
		};
		var union = function(_x, _y) {
			labels[find(_x)] = find(_y);	
		};
		
		for(var i=0; i<w; i++) {
			for (var j=0; j<h; j++) {
				var _tile = get_tile(i,j);	
				if is_undefined(_tile) { continue; }
				if array_contains(_tile.measures, measure_type) {
					left = label[i-1, j]
					above = label[i, j-1]
					if left == 0 and above == 0 {
						cur_label += 1
						label[i,j] = cur_label
						ds_map_add(cluster_map,cur_label,0)
					}
					else if left != 0 and above == 0 { label[i,j] = find(left) }
					else if left == 0 and above != 0 { label[i,j] = find(above)	}
					else {
						union(left,above)
						label[i,j] = find(left)
					}
				}
			}
		}
		
		return label;
	};

	//create cluster maps for ews cyclone and ews 
	var cluster_grid_cyclone = make_cluster_grid(MEASURE.EWS_CYCLONE);
	var cluster_grid_flood = make_cluster_grid(MEASURE.EWS_FLOOD);

	var errors = [];
	var make_error = function(_x,_y,_str) {
		var _square = coords_to_grid(_x, _y, false);
		array_push(errors, string("Error at square '{0},{1}': {2}",_x,_y,_square))
	};

	//check all land tiles and their measures
	for(var i=0; i<n; i++) {
		var tile = global.map.land_tiles[i];
		var tx = tile.x div 64;
		var ty = tile.y div 64;
		var measures = tile.measures;
		var check_implementing = function(measure_type) {
			var name = global.measures[? measure_type].name;
			if array_contains(tile.long_term,measure_type) or array_contains(tile.medium_term,measure_type) or array_contains(tile.short_term,measure_type) {
				var completion = "";
				if array_contains(tile.long_term,measure_type) { completion = "years remaining" }
				else if array_contains(tile.medium_term,measure_type) { completion = "months remaining" }
				else if array_contains(tile.short_term,measure_type) { completion = "weeks remaining" }
				make_error(tx,ty,string("Already implementing measure '{0}' on this square ({0}).",name,completion))	
			}
			else if array_contains(tile.implemented,measure_type) {
				make_error(tx,ty,string("Measure '{0}' is already implemented on this square.",name))	
			}
		};
		for(var j=0; j<array_length(measures); j++) {
			var _measure = measures[j];
			switch(_measure.key) {
				case MEASURE.HOSPITAL:
					if !global.map.hospital_grid[tx,ty] {
						make_error(tx,ty,"No hospitals exist to rebuild.")
					}
					else if !array_contains(global.state.affected_tiles, coords_to_grid(tx,ty,false)) {
						make_error(tx,ty,"Hospital does not need to be rebuilt (not affected by disaster.)")	
					}
				break;
				
				case MEASURE.BUILDINGS:
					if !array_contains(global.state.affected_tiles, coords_to_grid(tx,ty,false)) {
						make_error(tx,ty,"Cannot reconstruct buildings in an unimpacted tile.")	
					}
				break;
				
				case MEASURE.NBS:
					check_implementing(MEASURE.NBS)
					if tile.metrics.agricuture {
						make_error(tx,ty,"Cannot implement NBS on a square with agricultural crops.")	
					}
				break;
				
				case MEASURE.SEAWALL:
					check_implementing(MEASURE.SEAWALL)
					if !is_coastal(tx,ty) {
						make_error(tx,ty,"Cannot build a seawall on a non-coastal square.")
					}
				break;
				
				case MEASURE.NORMAL_CROPS:
				case MEASURE.RESISTANT_CROPS:
					check_implementing(MEASURE.NORMAL_CROPS)
					check_implementing(MEASURE.RESISTANT_CROPS)
					if tile.metrics.agricuture {
						make_error(tx,ty,"Cannot plant crops on a square that already has planted crops on it.")	
					}
					if tile.metrics.population >= 700 {
						make_error(tx,ty,"Cannot plant crops in densely populated squares.")
					}
				break;
				
				case MEASURE.DIKE:
					check_implementing(MEASURE.DIKE)
					if !global.map.river_grid[tx,ty] {
						make_error(tx,ty,"Cannot build a dike on a square without a river.")	
					}
				break;
			}
		}
		
	}
	
	ds_map_destroy(tile_map)
}