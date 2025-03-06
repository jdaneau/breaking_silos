//extension of end_round
function progress_round(){
	//generate next disaster
	global.state.next_disaster = get_next_disaster();
	var days = real(global.state.next_disaster.days_since_last_disaster);
	global.state.datetime = date_inc_day(global.state.datetime, days)
		
	//progress all projects and get a list of finished ones
	finished_projects = progress_projects(days);
		
	//update map changes
	update_buildings(finished_projects)
	update_map_measures(finished_projects)
	relocate_and_grow_population(finished_projects)
	increase_global_time(days);
	
	global.state.disaster = global.state.next_disaster.disaster
	global.state.disaster_intensity = global.state.next_disaster.intensity
	set_new_affected_area()
	
	//update round number
	global.state.current_round ++
}

function get_next_disaster(){
	var last_disaster = global.state.disaster;
	var next_disaster;
	var multi_hazard = true;
	var rand_value = random(1);
	switch(last_disaster) {
		case "flood":
		case "drought":
			//medium risk flood = 5% chance
			var _flood = 0.05 * get_risk_ratio("flood")
			//low risk drought = 2% chance
			var _drought = 0.02 * get_risk_ratio("drought")
			//medium risk cyclone = 5% chance
			var _cyclone = 0.05 * get_risk_ratio("cyclone")
			
			if rand_value <= _flood { next_disaster = "flood" }
			else if rand_value <= _flood + _drought { next_disaster = "drought" }
			else if rand_value <= _flood + _drought + _cyclone { next_disaster = "cyclone" }
			else { multi_hazard = false }
		break;
		
		case "cyclone":
			//high risk flood = 5% chance
			var _flood = 0.25 * get_risk_ratio("flood")
			//medium risk drought = 2% chance
			var _drought = 0.05 * get_risk_ratio("drought")
			//low risk cyclone = 5% chance
			var _cyclone = 0.02 * get_risk_ratio("cyclone")
			
			if rand_value <= _flood { next_disaster = "flood" }
			else if rand_value <= _flood + _drought { next_disaster = "drought" }
			else if rand_value <= _flood + _drought + _cyclone { next_disaster = "cyclone" }
			else { multi_hazard = false }
		break;
		
		default:
			multi_hazard = false
		break;
	}
	//don't allow two multi-hazard scenarios in a row
	if global.state.multi_hazard { multi_hazard = false; global.state.multi_hazard = false } 
	
	if multi_hazard {
		var n_days = irandom_range(1,14);
		global.state.multi_hazard = true
		var _intensity;
		switch(global.state.disaster_intensity) {
			case "low":
				_intensity = "low"
			break;
			case "medium":
				_intensity = choose("medium","low")
			break;
			case "high":
				_intensity = choose("high","medium","low")
			break;
		}
		return {
			disaster : next_disaster,
			intensity : _intensity,
			days_since_last_disaster : n_days
		}
	}
	else {
		rand_value = random(1)
		switch(objOnline.lobby_settings.landscape_type) {
			case "Island":
				//40% chance flood
				if rand_value <= 0.4 { next_disaster = "flood" }
				//20% chance drought
				else if rand_value <= 0.6 { next_disaster = "drought" }
				//40% chance cyclone
				else { next_disaster = "cyclone" }
			break;
			
			case "Coastal":
				//40% chance flood
				if rand_value <= 0.4 { next_disaster = "flood" }
				//30% chance drought
				else if rand_value <= 0.7 { next_disaster = "drought" }
				//30% chance cyclone
				else { next_disaster = "cyclone" }
			break;
			
			case "Continental":
				//40% chance flood
				if rand_value <= 0.4 { next_disaster = "flood"	}
				//45% chance drought
				else if rand_value <= 0.85 { next_disaster = "drought" }
				//15% chance cyclone
				else { next_disaster = "cyclone" }
			break;
		}
		
		var n_days = choose(30,365);
		var mult;
		switch(n_days) {
			case 30:
				mult = random_range(4,24)
				break;
			case 365:
				mult = random_range(1,3)
				break;
		}
		n_days = round(n_days * mult)
		
		rand_value = random(1)
		switch(objOnline.lobby_settings.climate_intensity) {
			case "High":
				//50% chance time = time/2
				if rand_value <= 0.5 { n_days = round(n_days / 2) }
				//25% chance time = time*(2/3)
				else if rand_value <= 0.75 { n_days = round(n_days * (2/3)) }
				//25% chance time = time*(3/4)
				else { n_days = round(n_days * (3/4)) }
			break;
			
			case "Medium":
				//40% chance time = time*(2/3)
				if rand_value <= 0.4 { n_days = round(n_days * (2/3)) }
				//40% chance time = time*(3/4)
				else if rand_value <= 0.8 { n_days = round(n_days * (3/4)) }
				//20% chance nothing
				else {}
			break;
			
			case "Low":
				//25% chance time = time*(3/4)
				if rand_value <= 0.25 { n_days = round(n_days * (3/4)) }
				//50% chance nothing
				else if rand_value <= 0.75 {}
				//25% chance time = time*(5/4)
				else { n_days = round(n_days * (5/4)) }
			break;
		}
		
		switch(objOnline.lobby_settings.climate_type) {
			case "Tropical":
				//50% chance time = time/2
				if rand_value <= 0.5 { n_days = round(n_days / 2) }
				//25% chance time = time*(2/3)
				else if rand_value <= 0.75 { n_days = round(n_days * (2/3)) }
				//25% chance time = time*(3/4)
				else { n_days = round(n_days * (3/4)) }
			break;
			
			case "Temperate":
				//40% chance time = time*(2/3)
				if rand_value <= 0.4 { n_days = round(n_days * (2/3)) }
				//40% chance time = time*(3/4)
				else if rand_value <= 0.8 { n_days = round(n_days * (3/4)) }
				//20% chance nothing
				else {}
			break;
			
			case "Boreal":
				//25% chance time = time*(3/4)
				if rand_value <= 0.25 { n_days = round(n_days * (3/4)) }
				//50% chance nothing
				else if rand_value <= 0.75 {}
				//25% chance time = time*(5/4)
			break;
		}
		
		n_days = round(n_days / sqr(get_risk_ratio(next_disaster)))
		
		var intensity = choose("low","medium","high");
		if next_disaster == "cyclone" {
			if objOnline.lobby_settings.landscape_type == "Continental" or objOnline.lobby_settings.climate_type == "Boreal"
				intensity = choose("low","low","medium")
		}
		if next_disaster == "drought" {
			if objOnline.lobby_settings.landscape_type == "Continental"
				intensity = choose("medium","medium","high")
			// add drought penalty for having too much agriculture
			var agri_surplus = get_total_agriculture() - global.map.starting_agriculture;
			if agri_surplus > 0 {
				rand_value = random(10)
				if rand_value <= agri_surplus { 
					if intensity == "low" intensity = "medium"
					else intensity = "high"
				}
			}
		}
		
		return {
			disaster : next_disaster,
			intensity : intensity,
			days_since_last_disaster : n_days
		}
	}
}

function increase_global_time(days) {
	var new_datetime = date_inc_day(global.state.datetime, days);
	
	//tax revenue
	var new_years = date_get_year(new_datetime) - date_get_year(global.state.datetime);
	if new_years > 0 {
		var tax_amount = round(new_years * global.state.base_tax * (get_total_population("thousands",false) / global.state.starting_population));
		global.state.state_budget += tax_amount;
		add_report(string("{0} new year{1} {2} passed, providing a tax income of {3} coins!",new_years,new_years > 1 ? "s" : "", new_years > 1 ? "have" : "has", tax_amount))
	}
}

function move_appeal(origTile,destTile) {
	var origX = origTile.x div 64; var origY = origTile.y div 64;
	var destX = destTile.x div 64; var destY = destTile.y div 64;
	var distance = euclidean_distance(origX,origY,destX,destY);
	var appeal = clamp(1/(distance / 2),0,1);
	if global.map.hospital_grid[origX,origY] > global.map.hospital_grid[destX,destY] { appeal *= 0.4 }
	if global.map.airport_grid[origX,origY] > global.map.airport_grid[destX,destY] { appeal *= 0.4 }
	if global.map.buildings_grid[origX,origY] > global.map.buildings_grid[destX,destY] { appeal *= 0.25 }
	appeal *= agricultural_availability(destTile)
	return appeal
}

function relocate_and_grow_population(finished_projects) {
	
	var years_passed = global.state.next_disaster.days_since_last_disaster / 365;
	
	var returned_population = 0;
	
	//return previously evacuated population
	var base_return_amount = clamp(years_passed,0,1); //assumed that evacuated population moves back within a year, unless their origin tile is still damaged
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		var remaining_evacuated = [];
		while(array_length(tile.evacuated_population) > 0) {
			var struct = array_pop(tile.evacuated_population);
			var targetTile = tile_from_square(struct.origin);
			var return_amount = struct.population * base_return_amount;
			return_amount = round(clamp(return_amount * move_appeal(tile,targetTile),0,struct.population))
			if return_amount == struct.population {
				targetTile.metrics.population += struct.population;
			} else {
				struct.population -= return_amount
				array_push(remaining_evacuated, struct)
				targetTile.metrics.population += return_amount
			}
			returned_population += return_amount
		}
		tile.evacuated_population = remaining_evacuated
	}
	add_report(string("{0} citizens returned back home from their temporary shelters.",returned_population*1000))
	
	//relocation incentive
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		if is_implementing(tile,MEASURE.RELOCATION) or just_completed(tile,MEASURE.RELOCATION,finished_projects) {
			var candidate_tiles = [];
			for(var j=0; j<array_length(global.map.land_tiles); j++) {
				var _candidate = global.map.land_tiles[j];
				if _candidate.x == tile.x and _candidate.y == tile.y { continue }
				if array_contains(global.state.affected_tiles, coords_to_grid(_candidate.x,_candidate.y)) { continue }
				array_push(candidate_tiles,_candidate)
			}
			var candidates_and_appeal = [];
			for(var j=0; j<array_length(candidate_tiles); j++) {
				array_push(candidates_and_appeal, {tile:candidate_tiles[j], appeal:move_appeal(tile,candidate_tiles[j])} )
			}
			array_sort(candidates_and_appeal, function(elm1,elm2) {
				if elm1.appeal == elm2.appeal return 0
				else if elm1.appeal > elm2.appeal return -1
				else return 1
			})
			var amt_time_passed = global.state.next_disaster.days_since_last_disaster / get_implementing(tile,MEASURE.RELOCATION).days_remaining;
			var population_to_move = round(tile.starting_population * 0.3 * amt_time_passed);
			tile.metrics.population -= population_to_move
			var index = 0;
			var amount_per_step = population_to_move/10;
			while(population_to_move > 0) {
				var moving = clamp(round(amount_per_step * random_range(0.8,1.2)),0,population_to_move);
				var tileMovingTo = candidates_and_appeal[index].tile;
				tileMovingTo.metrics.population += moving
				population_to_move -= moving
				index += choose(1,2,3)
			}
			
			just_completed(tile,MEASURE.RELOCATION,finished_projects) {
				add_report(string("A relocation incentive has finished on cell {0}, with {1} total people moving away!",coords_to_grid(tile.x,tile.y),round(tile.starting_population*0.3)*1000))
			}
		}
	}
	
	//natural population growth
	var pop_growth = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		//assuming random growth between 0.1-0.5% per year
		var growth_factor = 1 + (random_range(0.001,0.005) * years_passed);
		var old_pop = _tile.metrics.population;
		_tile.metrics.population = round(_tile.metrics.population * growth_factor)
		pop_growth += (_tile.metrics.population - old_pop)
	}
	if pop_growth > 0 {
		add_report(string("Natural population growth has increased our population by {0}.",round(pop_growth*1000)))
	}
}

function set_new_affected_area() {
	var center = get_disaster_center();
	define_blob_patterns()
	var blob_array;
	var candidate_spots;
	switch(global.state.disaster_intensity) {
		case "low":
			blob_array = global.blob_patterns.low;
			candidate_spots = [[0,1],[1,0],[1,1],[1,2],[2,1]]
		break;
		case "medium":
			blob_array = global.blob_patterns.medium;
			candidate_spots = [[1,1],[1,2],[2,1],[2,2]]
		break;
		case "high":
			blob_array = global.blob_patterns.high;
			candidate_spots = [[1,2],[2,1],[2,2],[2,3],[3,2]]
		break;
	}
	var map_key = "";
	switch(global.state.disaster) {
		case "cyclone":
			map_key = "cyclone_risk"
		break;
		case "flood":
			map_key = "flood_risk"
		break;
		case "drought":
			map_key = "drought_risk"
		break;
	}
	var blob = blob_array[irandom(4)];
	var blob_size = array_length(blob);
	repeat(irandom(3)) { blob = rotate_blob(blob) } //start from random rotation as not to prioritize any orientation
	var best_blob;
	var best_spot;
	var best_score = 0;
	
	//find the spot that maximizes risk by rotating the chosen blob around and overlaying it on the map at different points
	for(var i=0; i<4; i++) {
		for(var j=0; j<array_length(candidate_spots); j++) {
			var _score = 0;
			var spot = candidate_spots[j];
			var spot_x = spot[1];
			var spot_y = spot[0];
			for(var _i=0; _i<blob_size; _i++) {
				var row = blob[_i];
				for(var _j=0; _j<blob_size; _j++) {
					if string_char_at(row,_j+1) == "x" {
						var tx = center[0] - spot_x + _j;
						var ty = center[1] - spot_y + _i;
						var tile = tile_from_coords(tx,ty);
						if tile != noone {
							_score += tile.metrics[$ map_key]
						}
					}
				}
			}
			if _score > best_score {
				best_blob = blob
				best_spot = candidate_spots[j]
				best_score = _score
			}
		}
		blob = rotate_blob(blob)
	}
	
	//add affected tiles
	global.state.affected_tiles = []
	for(var i=0; i<blob_size; i++) {
		var row = best_blob[i];
		for(var j=0; j<blob_size; j++) {
			if string_char_at(row,j+1) == "x" {
				var tx = center[0] - best_spot[1] + j;
				var ty = center[1] - best_spot[0] + i;
				if global.map.land_grid[tx,ty] {
					array_push(global.state.affected_tiles, coords_to_grid(tx,ty,false))
				}
			}
		}
	}	
}

function get_disaster_center() {
	var map_key = "";
	switch(global.state.disaster) {
		case "cyclone":
			map_key = "cyclone_risk"
		break;
		case "flood":
			map_key = "flood_risk"
		break;
		case "drought":
			map_key = "drought_risk"
		break;
	}
	
	//for multi-hazard scenarios: choose a spot that's already affected based on risk value
	if global.state.multi_hazard {
		var candidate_spots = [];
		for(var i=0; i<array_length(global.state.affected_tiles); i++) {
			var amt = tile_from_square(global.state.affected_tiles[i]).metrics[$ map_key];
			if amt > 0 { 
				repeat amt array_push(candidate_spots,global.state.affected_tiles[i])
			}
		}
		if array_length(candidate_spots) > 0 {
			candidate_spots = array_shuffle(candidate_spots)
			var spot = candidate_spots[0];
			var spot_coords = grid_to_coords(spot,false);
			return [spot_coords[0], spot_coords[1]]
		}
	}
	
	//else: choose a random spot based on risk 
	var candidate_tiles = [];
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		// insert n copies of the tile into candidate array, where n is the tile's risk value for the given disaster
		if tile.metrics[$ map_key] > 0 {
			repeat tile.metrics[$ map_key] {
				array_push(candidate_tiles,tile);	
			}
		}
	}
	var chosen_tile = candidate_tiles[irandom(array_length(candidate_tiles)-1)];
	return [chosen_tile.x div 64, chosen_tile.y div 64]
}

function rotate_blob(blob) {
	var n = array_length(blob);
	var new_blob = array_create(n, "");
	
	for(var i=0; i<n; i++) {
		for(var j=0; j<n; j++) {
			new_blob[j] = string_char_at(blob[n-1-i],j+1) + new_blob[j]
		}
	}
	return new_blob
}