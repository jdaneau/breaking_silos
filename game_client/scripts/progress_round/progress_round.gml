//extension of end_round
function progress_round(){
	//generate next disaster
	global.state.next_disaster = get_next_disaster();
	var days = real(global.state.next_disaster.days_since_last_disaster);
	global.state.disaster = global.state.next_disaster.disaster
		
	//progress all projects and get a list of finished ones
	finished_projects = progress_projects(days);
		
	//update map changes
	update_buildings(finished_projects)
	update_map_measures(finished_projects)
	relocate_and_grow_population(finished_projects)
	increase_global_time(days);
}

//todo: make this more realistic (i.e. based on the map and current climate scenario)
function get_next_disaster(){
	return {
		disaster : choose("flood","drought","cyclone"),
		intensity : choose("low","medium","high"),
		days_since_last_disaster : choose(7,30,365) * irandom_range(2,4)
	}
}

function increase_global_time(days) {
	var new_datetime = date_inc_day(global.state.datetime, days);
	
	//tax revenue
	var new_years = date_get_year(new_datetime) - date_get_year(global.state.datetime);
	if new_years > 0 {
		var tax_amount = new_years * global.state.base_tax * (get_total_population("thousands") / global.map.starting_population);
		global.state.state_budget += tax_amount;
		add_report(string("{0} new year{1} {2} passed, providing a tax income of {3} coins!",new_years,new_years > 1 ? "s" : "", new_years > 1 ? "have" : "has", tax_amount))
	}
}

function relocate_and_grow_population(finished_projects) {
	//relocation incentive
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		if just_completed(tile,MEASURE.RELOCATION,finished_projects) {
			var candidate_tiles = [];
			for(var j=0; j<array_length(global.map.land_tiles); j++) {
				var _candidate = global.map.land_tiles[j];
				if _candidate.x == tile.x and _candidate.y == tile.y { continue }
				if array_contains(global.state.affected_tiles, coords_to_grid(_candidate.x,_candidate.y)) { continue }
				array_push(candidate_tiles,_candidate)
			}
			var moveAppeal = function(origTile,destTile) {
				var origX = origTile.x div 64; var origY = origTile.y div 64;
				var destX = destTile.x div 64; var destY = destTile.y div 64;
				var distance = euclidean_distance(origX,origY,destX,destY);
				var appeal = 1/(distance / 3);
				if global.map.hospital_grid[destX,destY] > 0 { appeal *= 1.5 }
				if global.map.airport_grid[destX,destY] > 0 { appeal *= 1.5 }
				appeal *= agricultural_availability(destTile)
				return appeal
			};
			var candidates_and_appeal = [];
			for(var j=0; j<array_length(candidate_tiles); j++) {
				array_push(candidates_and_appeal, {tile:candidate_tiles[j], appeal:moveAppeal(tile,candidate_tiles[j])} )
			}
			candidates_and_appeal = array_sort(candidates_and_appeal, function(elm1,elm2) {
				if elm1.appeal == elm2.appeal return 0
				else if elm1.appeal > elm2.appeal return -1
				else return 1
			})
			var population_to_move = tile.metrics.population * 0.3;
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
		}
	}
	
	//natural population growth
	var years_passed = global.state.next_disaster.days_since_last_disaster / 365;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		//assuming random growth between 1-2% per year
		_tile.metrics.population *= ( 1 + (random_range(0.01,0.02) * years_passed) )
	}
}