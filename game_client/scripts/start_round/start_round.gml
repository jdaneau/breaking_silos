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
	
	send_state()
	send_updated_map()
	room_goto(rInGame)
}

function do_map_damages(){
	
	global.state.n_projects_interrupted = 0
	global.state.n_agriculture_lost = 0
	global.state.n_airports_damaged = 0
	global.state.n_hospitals_damaged = 0
	global.state.n_tiles_damaged = 0
	
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		var tx = tile.x div 64;
		var ty = tile.y div 64;

		//set damages on the map
		switch(global.state.disaster) {
			case "flood":
				if global.map.buildings_grid[tx,ty] != 2 && !has_implemented(tile,MEASURE.DIKE,[]) && !tile.dammed{
					global.map.buildings_grid[tx,ty] = -1
					global.state.n_tiles_damaged++
				}
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 && !has_implemented(tile,MEASURE.SEAWALL,[]) && !tile.dammed{
						global.map.hospital_grid[tx,ty] = -1
						global.state.n_hospitals_damaged++
					}
					if global.map.airport_grid[tx,ty] == 1 && !has_implemented(tile,MEASURE.SEAWALL,[]) && !tile.dammed{
						global.map.airport_grid[tx,ty] = -1
						global.state.n_airports_damaged++
					}
					if tile.metrics.agriculture != 0 { 
						tile.metrics.agriculture = -1 
						global.state.n_agriculture_lost++
					}
				} else {
					if tile.metrics.agriculture == 2 { 
						tile.metrics.agriculture = -1 
						global.state.n_agriculture_lost++
					}
				}
			break;
			
			case "cyclone":
				if global.map.buildings_grid[tx,ty] != 3 && !has_implemented(tile,MEASURE.SEAWALL,[]){
					global.map.buildings_grid[tx,ty] = -1
					global.state.n_tiles_damaged++
				}
				if global.state.disaster_intensity != "low" {
					if global.map.hospital_grid[tx,ty] == 1 && !has_implemented(tile,MEASURE.SEAWALL,[]){
						global.map.hospital_grid[tx,ty] = -1
						global.state.n_hospitals_damaged++
					}
					if global.map.airport_grid[tx,ty] == 1 && !has_implemented(tile,MEASURE.SEAWALL,[]){
						global.map.airport_grid[tx,ty] = -1
						global.state.n_airports_damaged++
					}
				}
				if tile.metrics.agriculture != 0 { 
					tile.metrics.agriculture = -1 
					global.state.n_agriculture_lost++
				}
			break;
			
			case "drought":
				if tile.metrics.agriculture == 1 { 
					tile.metrics.agriculture = -1 
					global.state.n_agriculture_lost++
				}
			break;
		}
		
		switch(global.state.disaster_intensity) {
			case "low":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					var amount = random_range(1.1,1.3); // 10-30% time delay
					tile.in_progress[p].days_remaining = round(tile.in_progress[p].days_remaining * amount)
					global.state.n_projects_interrupted++
				}
			break;
			
			case "medium":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					var amount = random_range(1.3,1.6); // 30-60% time delay
					tile.in_progress[p].days_remaining = round(tile.in_progress[p].days_remaining * amount)
					global.state.n_projects_interrupted++
				}
			break;
			
			case "high":
				for(var p=0; p<array_length(tile.in_progress); p++) {
					var amount = random_range(1.6,1.9); // 60-90% time delay
					tile.in_progress[p].days_remaining = round(tile.in_progress[p].days_remaining * amount)
					global.state.n_projects_interrupted++
				}
			break;
		}
	}
}

function init_state() {
	global.state.datetime = date_current_datetime()
	global.state.seconds_remaining = global.time_limits.discussion
	var tax_mult = 1;
	switch(objOnline.lobby_settings.gdp) {
		case "High":
			global.state.state_budget = 45000
			tax_mult = 1.5
		break;
		case "Average":
			global.state.state_budget = 30000
		break;
		case "Low":
			global.state.state_budget = 15000
			tax_mult = 0.5
		break;
	}
	var normal_population = get_total_population("raw");
	var new_population = 0;
	var pop_mult = 1;
	if objOnline.lobby_settings.population == "High" pop_mult = 4;
	else if objOnline.lobby_settings.population == "Low" pop_mult = 0.2;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		_tile.metrics.population = round_nearest(_tile.metrics.population * pop_mult, 25);
		new_population += (_tile.metrics.population * 1000);
	}
	global.state.starting_population = new_population / 1000
	global.state.base_tax = 10000 * (new_population / normal_population) * tax_mult
}
