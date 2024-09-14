function end_round(){
	var errors = check_map_placement()
	if array_length(errors) > 0 {
		for(var i=0; i<array_length(errors); i++) {
			with objSidebarGUIChat chat_add(errors[i])
		}
	} else {
		for(var i=0; i<array_length(global.map.land_tiles); i++) {
			var _tile = global.map.land_tiles[i];
			while array_length(_tile.measures) > 0 {
				var _measure = array_pop(_tile.measures);
				var measure_struct = global.measures[? _measure];
				switch(measure_struct.time) {
					case "years":
						array_push(_tile.long_term, _measure)
						break;
					case "months":
						array_push(_tile.medium_term, _measure)
						break;
					case "weeks":
						array_push(_tile.short_term, _measure)
						break;
				}
			}
		}
		
		//update map changes
		updateBuildings()
		updatePopulation()
	}
}

//used by some of the below functions
function getMeasureLists() {
	var struct = {};
	var _measures = ds_map_values_to_array(global.measures);
	for(var i=0; i<array_length(_measures); i++) {
		var _measure = _measures[i];
		struct[? _measure.alias] = [];
	}
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		for(var m=0; m<array_length(tile.measures); m++) {
			var measure = tile.measures[m];
			var alias = global.measures[? measure].alias;
			array_push(struct[? alias], tile)
		}
	}
	return struct
}

function updateBuildings() {
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;
		//handle buildings being repaired on affected tiles
		if array_contains(global.state.affected_tiles, coords_to_grid(_tile.x,_tile.y)) {
			if array_contains(_tile.short_term, MEASURE.BUILDINGS) {
				//repair buildings on same round - nothing happens
				var delete_index = array_index(_tile.short_term, MEASURE.BUILDINGS);
				array_delete(_tile.short_term,delete_index,1)
			} else {
				//didn't repair buildings, set them to damaged
				global.map.buildings_grid[tx, ty] = -1	
			}
			if global.map.hospital_grid[tx,ty] > 0 {
				global.map.hospital_grid[tx,ty] = -1
			}
			if global.map.airport_grid[tx,ty] > 0 {
				if array_contains(_tile.short_term, MEASURE.AIRPORT) {
					//repair airport on same round - nothing happens
					var delete_index = array_index(_tile.short_term, MEASURE.AIRPORT);
					array_delete(_tile.short_term,delete_index,1)	
				} else {
					global.map.airport_grid[tx,ty] = -1
				}
			}
		}
		//handle buildings that are built on other tiles
		else {
			if array_contains(_tile.short_term, MEASURE.BUILDINGS)	{
				//repairing buildings that were damaged before
				var delete_index = array_index(_tile.short_term, MEASURE.BUILDINGS);
				array_delete(_tile.short_term,delete_index,1)
				global.map.buildings_grid[tx, ty] = 1
			}
			if array_contains(_tile.short_term, MEASURE.HOSPITAL)	{
				//repairing hospitals that were damaged before
				var delete_index = array_index(_tile.short_term, MEASURE.HOSPITAL);
				array_delete(_tile.short_term,delete_index,1)
				global.map.hospital_grid[tx, ty] = 1
			}
			if array_contains(_tile.short_term, MEASURE.AIRPORT)	{
				//repairing airports that were damaged before
				var delete_index = array_index(_tile.short_term, MEASURE.AIRPORT);
				array_delete(_tile.short_term,delete_index,1)
				global.map.airport_grid[tx, ty] = 1
			}
		}
	}
}

function updatePopulation() {
	var measureLists = getMeasureLists()
	
	//return previously evacuated population
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		while(array_length(tile.evacuated_population) > 0) {
			var struct = array_pop(tile.evacuated_population);
			var targetTile = tile_from_square(struct.origin);
			targetTile.metrics.population += struct.population;
		}
	}
	
	//evacuate population from affected tiles
	var evacuateList = measureLists.evacuate;
	if typeof(evacuateList) == "array" { //need this or else the compiler complains to me
		for(var i=0; i<array_length(evacuateList); i++) {
			var tile = evacuateList[i];
			//continue here :)
		}
	}
	
	//population loss on tiles
	
	//relocation incentive
}