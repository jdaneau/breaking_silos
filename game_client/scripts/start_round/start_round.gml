function start_round() {
	// first round 
	if global.state.current_round == 1 { 
		init_state()
		var first_disaster = get_next_disaster();
		global.state.disaster = first_disaster.disaster;
		global.state.disaster_intensity = first_disaster.intensity;
		set_new_affected_area()
		do_map_damages()
	}
	
	global.state.round_reports = []
	global.state.measures_implemented = array_create(global.N_MEASURES, 0)
	global.state.money_spent = 0
	global.state.current_phase = "discussion"	
	global.state.seconds_remaining = global.time_limits.discussion
	global.state.time_remaining = game_get_speed(gamespeed_fps) * global.time_limits.discussion
	global.state.aid_objectives = {
		buildings : false,
		hospitals : false,
		airport : false,
		agriculture : false
	}
	
	send_struct(MESSAGE.STATE, global.state)
	send_chunked_string(MESSAGE.MAP,json_stringify(global.map))
	room_goto(rInGame)
}

function do_map_damages(){
	
	global.n_projects_interrupted = 0
	global.n_agriculture_lost = 0
	global.n_airports_damaged = 0
	global.n_hospitals_damaged = 0
	global.n_tiles_damaged = 0
	
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		var tx = tile.x div 64;
		var ty = tile.y div 64;

		//set damages on the map
		switch(global.state.disaster) {
			case "flood":
				global.map.buildings_grid[tx,ty] = -1
				global.n_tiles_damaged++
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 {
						global.map.hospital_grid[tx,ty] = -1
						global.n_hospitals_damaged++
					}
					if global.map.airport_grid[tx,ty] == 1 {
						global.map.airport_grid[tx,ty] = -1
						global.n_airports_damaged++
					}
					if tile.metrics.agriculture != 0 { 
						tile.metrics.agriculture = -1 
						global.n_agriculture_lost++
					}
				} else {
					if tile.metrics.agriculture == 2 { 
						tile.metrics.agriculture = -1 
						global.n_agriculture_lost++
					}
				}
			break;
			
			case "cyclone":
				global.map.buildings_grid[tx,ty] = -1
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 {
						global.map.hospital_grid[tx,ty] = -1
						global.n_hospitals_damaged++
					}
					if global.map.airport_grid[tx,ty] == 1 {
						global.map.airport_grid[tx,ty] = -1
						global.n_airports_damaged++
					}
				}
				if tile.metrics.agriculture != 0 { 
					tile.metrics.agriculture = -1 
					global.n_agriculture_lost++
				}
			break;
			
			case "drought":
				if tile.metrics.agriculture == 1 { 
					tile.metrics.agriculture = -1 
					global.n_agriculture_lost++
				}
			break;
		}
		
		switch(global.state.disaster_intensity) {
			case "low":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 7 * random_range(1,4) // add 1-4 weeks extra time
					global.n_projects_interrupted++
				}
			break;
			
			case "medium":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 30 * random_range(2,12) // add 2-12 months extra time
					global.n_projects_interrupted++
				}
			break;
			
			case "high":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					tile.in_progress[p].days_remaining += 365 * random_range(1,2) // add 1-2 years extra time
					global.n_projects_interrupted++
				}
			break;
		}
	}
}

function init_state() {
	global.state.datetime = date_current_datetime()
	global.state.seconds_remaining = global.time_limits.discussion
	global.state.state_budget = 30000
	global.state.base_tax = 10000
}
