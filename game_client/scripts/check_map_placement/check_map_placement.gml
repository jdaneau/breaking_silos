//checks for valid placement of measures on the map
function check_map_placement(measure,tile) {	
	var tx = tile.x div 64;
	var ty = tile.y div 64;

	var name = global.measures[? measure].name;
	if is_implementing(tile,measure) {
		var completion = "";
		var days = get_implementing(tile,measure).days_remaining;
		if days < 60 { completion = "weeks remaining" }
		else if days < (365*2) { completion = "months remaining" }
		else { completion = "years remaining" }
		return string("Already implementing measure '{0}' on this cell ({0}).",name,completion)	
	}
	else if array_contains(tile.implemented,measure) {
		return string("Measure '{0}' is already implemented on this cell.",name)
	}

	switch(measure) {
		case MEASURE.HOSPITAL:
			if global.map.hospital_grid[tx,ty] == 0 {
				return "No hospital exists on this sqaure."
			}
			else if global.map.hospital_grid[tx,ty] == 1 {
				return "Hospital is not damaged."
			}
		break;
				
		case MEASURE.AIRPORT:
			if global.map.airport_grid[tx,ty] == 0 {
				return "No airport exists on this sqaure."
			}
			else if global.map.airport_grid[tx,ty] == 1 {
				return "Airport is not damaged."
			}
		break;
				
		case MEASURE.BUILDINGS:
			if global.map.buildings_grid[tx,ty] == 1 {
				return "The buildings in this sqaure are not damaged."
			}
		break;
				
		case MEASURE.NBS:
			if tile.metrics.agriculture {
				return "Cannot implement NBS on a cell with agricultural crops."
			}
		break;
				
		case MEASURE.SEAWALL:
			if !is_coastal(tx,ty) {
				return "Cannot build a seawall on a non-coastal cell."
			}
		break;
				
		case MEASURE.NORMAL_CROPS:
		case MEASURE.RESISTANT_CROPS:
			if tile.metrics.agriculture > 0 {
				return "Cannot plant crops on a cell that already has planted crops on it."
			}
			if tile.metrics.population >= 700 {
				return "Cannot plant crops in densely populated cells."
			}
		break;
				
		case MEASURE.DIKE:
			if !global.map.river_grid[tx,ty] {
				return "Cannot build a dike on a cell without a river."
			}
		break;
				
		case MEASURE.EVACUATE:
			if array_contains(global.state.affected_tiles, coords_to_grid(tx,ty,false)) {
				return "Cannot evacuate population to an affected cell."
			}
			var num_evacuated = 0;
			for(var i=0; i<array_length(global.map.land_tiles); i++) {
				if array_contains(global.map.land_tiles[i].measures,MEASURE.EVACUATE) num_evacuated++
			}
			if num_evacuated > array_length(global.state.affected_tiles) {
				return "Cannot evacuate to more cells than were affected by the disaster."
			}
		break;
				
		case MEASURE.DAM:
			if !global.map.river_grid[tx,ty] {
				return "Cannot build a dam on a cell without a river."
			}
			var upstream_tiles = get_upstream_tiles(tile);
			if array_length(upstream_tiles) == 0 {
				return "Cannot build a dam on a river source."	
			}
			var watershed_tiles = get_tiles_in_watershed(tile.metrics.watershed);
			var implementing = false;
			var built = false;
			for(var _t = 0; _t < array_length(watershed_tiles); _t++) {
				var _tile = watershed_tiles[_t];
				if array_contains(_tile.measures,MEASURE.DAM) and (_tile.x != tile.x or _tile.y != tile.y) {
					return "You cannot construct two dams in the same watershed."
				}
				if is_implementing(_tile, MEASURE.DAM) implementing = true
				if has_implemented(_tile, MEASURE.DAM, []) built = true
			}
			if implementing {
				return "A dam is currently already being built in this watershed."
			}
			else if built {
				return "A dam has already been built in this watershed."
			}
		break;
		
		case MEASURE.RELOCATION:
		case MEASURE.EWS_FLOOD:
		case MEASURE.EWS_CYCLONE:
			//nothing
		break;
	}
	
	return "OK"
}