function start_round(){
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		var tx = tile.x div 64;
		var ty = tile.y div 64;
		
		//set damages on the map
		switch(global.state.disaster) {
			case "flood":
				global.map.buildings_grid[tx,ty] = -1
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 global.map.hospital_grid[tx,ty] = -1
					if global.map.airport_grid[tx,ty] == 1 global.map.airport_grid[tx,ty] = -1
					if tile.metrics.agriculture != 0 { tile.metrics.agriculture = -1 }
				} else {
					if tile.metrics.agriculture == 2 { tile.metrics.agriculture = -1 }
				}
			break;
			
			case "cyclone":
				global.map.buildings_grid[tx,ty] = -1
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 global.map.hospital_grid[tx,ty] = -1
					if global.map.airport_grid[tx,ty] == 1 global.map.airport_grid[tx,ty] = -1
				}
				if tile.metrics.agriculture != 0 { tile.metrics.agriculture = -1 }
			break;
			
			case "drought":
				if tile.metrics.agriculture == 1 { tile.metrics.agriculture = -1 }
			break;
		}
		
		switch(global.state.disaster_intensity) {
			case "low":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 7 * random_range(1,4) // add 1-4 weeks extra time
				}
			break;
			
			case "medium":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 30 * random_range(2,12) // add 2-12 months extra time
				}
			break;
			
			case "high":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 365 * random_range(1,2) // add 1-2 years extra time
				}
			break;
		}
	}
	
	//reset variables
	global.state.round_reports = []
	global.state.measures_implemented = array_create(global.N_MEASURES, 0)
	global.state.money_spent = 0
	global.state.current_phase = "discussion"
}