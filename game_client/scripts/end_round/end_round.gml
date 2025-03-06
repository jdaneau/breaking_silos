function end_round(){
	//reset aid objectives
	global.state.aid_objectives.buildings = true;
	global.state.aid_objectives.hospitals = true;
	global.state.aid_objectives.airport = true;
	global.state.aid_objectives.agriculture = true;
	var airport_pop = 0;
	var n_evacuate = 0;
	var n_buildings = 0;
	var n_agriculture = 0;
	var n_remaining_agriculture = 0;
		
	//move measures into the in_progress array for each tile (and count measures for the aid objectives)
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		if _tile.metrics.agriculture > 0 || is_implementing(_tile,MEASURE.NORMAL_CROPS) || is_implementing(_tile,MEASURE.RESISTANT_CROPS) { n_remaining_agriculture++ }
		while array_length(_tile.measures) > 0 {
			var _measure = array_pop(_tile.measures);
			global.state.measures_implemented[_measure] += 1
			if _measure == MEASURE.AIRPORT && array_contains(global.state.affected_tiles,coords_to_grid(_tile.x,_tile.y)) {
				var pop = _tile.metrics.population;
				if pop > airport_pop { airport_pop = pop }
			}
			if _measure == MEASURE.EVACUATE { n_evacuate++ }
			if _measure == MEASURE.BUILDINGS or _measure == MEASURE.FLOOD_BUILDINGS or _measure == MEASURE.CYCLONE_BUILDINGS { n_buildings++ }
			if _measure == MEASURE.NORMAL_CROPS or _measure == MEASURE.RESISTANT_CROPS { n_agriculture++ }
			var measure_struct = global.measures[? _measure];
			global.state.money_spent += measure_struct.cost
			var new_struct = {
				measure: _measure	
			};
			new_struct.days_remaining = get_project_days(_measure)
			new_struct.original_days_remaining = new_struct.days_remaining
			array_push(_tile.in_progress, new_struct)
			global.map.measures_implemented++
		}
	}
		
	//determine if the aid objectives were met
	var obj_airport_pop = 0;
	var n_affected_hospitals = 0;
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var _tile = tile_from_square(global.state.affected_tiles[i]);
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;
		if global.map.hospital_grid[tx, ty] == -1 {
			if !is_implementing(_tile, MEASURE.HOSPITAL) {
				global.state.aid_objectives.hospitals = false	
			}
		}
		if global.map.airport_grid[tx, ty] == -1 {
			if _tile.metrics.population > obj_airport_pop {
				obj_airport_pop = _tile.metrics.population
			}
		}
	}
	if airport_pop != obj_airport_pop { 
		global.state.aid_objectives.airport = false 
	}
	if n_evacuate + n_buildings < array_length(global.state.affected_tiles) {
		//dont bother evacuating in the case of a low-intensity drought
		if global.state.disaster != "drought" or global.state.disaster_intensity != "low" {
			global.state.aid_objectives.buildings = false	
		}
	}
	if n_agriculture + n_remaining_agriculture < global.map.starting_agriculture {
		global.state.aid_objectives.agriculture = false	
	}
		
	if global.state.aid_objectives.airport
	and global.state.aid_objectives.buildings
	and global.state.aid_objectives.hospitals
	and global.state.aid_objectives.agriculture {
		global.state.state_budget += 5000 // reward for meeting all aid objectives 
	}
		
	//automatically finish all "instant" projects 
	var finished_projects = progress_projects(1);
		
	//update map changes
	update_buildings(finished_projects)
	update_map_measures(finished_projects)
	update_population_loss(finished_projects)
		
	//go to the results screen
	global.state.current_phase = "results"
		
	if instance_exists(objOnline) {
		//update other players
		send_state()
		send_updated_map()
		send(MESSAGE.END_ROUND)
	}
		
	room_goto(rRoundResults)
	global.state.current_room = rRoundResults
}

function get_project_days(_measure,_max=false) {
	var _time = global.measures[? _measure].time;
	var lobby_rounds = objOnline.lobby_settings.n_rounds;
	var _min_time = 0;
	var _max_time = 0;
	switch(_time) {
		case "instant":
			_min_time = 1;
			_max_time = 1;
		break;
		case "weeks":
			if lobby_rounds < 3 { _min_time = 2; _max_time = 7 }
			if lobby_rounds == 3 { _min_time = 2; _max_time = 14 }
			if lobby_rounds > 3 { _min_time = 2; _max_time = 28 }
		break;
		case "months":
			if lobby_rounds < 3 { _min_time = 30; _max_time = 60 }
			if lobby_rounds == 3 { _min_time = 40; _max_time = 120 }
			if lobby_rounds > 3 { _min_time = 60; _max_time = 365 }
		break;
		case "years":
			if lobby_rounds < 3 { _min_time = 365; _max_time = 400 }
			if lobby_rounds == 3 { _min_time = 365; _max_time = 730 }
			if lobby_rounds > 3 { _min_time = 365; _max_time = 1095 }
		break;
	}
	if _max { _min_time = _max_time }
	return irandom_range(_min_time, _max_time)
}

// adds a report to the list of messages to show at the end of the round
function add_report(msg) {
	array_push(global.state.round_reports, msg)
}

// progresses all the projects in each tile and also returns a list of the ones that were finished
function progress_projects(days) {
	var finished = [];
	var unfinished = [];
	
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		while(array_length(tile.in_progress) > 0) {
			var struct = array_pop(tile.in_progress);
			var days_remaining = struct.days_remaining;
			var original_days_remaining = struct.original_days_remaining;
			struct.days_remaining -= days;
			if struct.days_remaining <= 0 {
				array_push(finished,{tile:tile,measure:struct.measure,days_remaining:days_remaining,original_days_remaining:original_days_remaining})
			} else {
				array_push(unfinished,struct)
			}
		}
		while(array_length(unfinished) > 0) {
			array_push(tile.in_progress, array_pop(unfinished))	
		}
	}
	return finished
}	

//functions to check for measures being completed/implemented on certain tiles (used below)
function just_completed(tile,measure,finished_projects) {
	var index = -1;
	for(var i=0; i<array_length(finished_projects); i++) {
		var _tile = finished_projects[i].tile;
		var _measure = finished_projects[i].measure;
		if _tile.x == tile.x && _tile.y == tile.y && _measure == measure {
			index = i
			break;
		}
	}
	return (index >= 0)
}
function has_implemented(tile,measure,finished_projects) {
	return array_contains(tile.implemented, measure) or just_completed(tile,measure,finished_projects)
}

// update buildings, hospitals, airports
function update_buildings(finished_projects) {
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;

		//repairing buildings that were damaged before
		if just_completed(_tile, MEASURE.BUILDINGS, finished_projects) {
			global.map.buildings_grid[tx, ty] = 1
		}
		if just_completed(_tile, MEASURE.FLOOD_BUILDINGS, finished_projects) {
			global.map.buildings_grid[tx, ty] = 2
		}
		if just_completed(_tile, MEASURE.CYCLONE_BUILDINGS, finished_projects) {
			global.map.buildings_grid[tx, ty] = 3
		}
		if just_completed(_tile, MEASURE.HOSPITAL, finished_projects) {
			global.map.hospital_grid[tx, ty] = 1
			global.map.hospitals_repaired++
		}
		if just_completed(_tile, MEASURE.AIRPORT, finished_projects) {
			global.map.airport_grid[tx, ty] = 1
			global.map.airports_repaired++
		}
	}
}

// update all other measure types
function update_map_measures(finished_projects) {
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		
		//dike
		if just_completed(tile,MEASURE.DIKE,finished_projects) {
			array_push(tile.implemented, MEASURE.DIKE)	
			tile.metrics.flood_risk = clamp(tile.metrics.flood_risk-1,0,3)
		}
	
		//seawall
		if just_completed(tile,MEASURE.SEAWALL,finished_projects) {
			array_push(tile.implemented, MEASURE.SEAWALL)	
			tile.metrics.flood_risk = clamp(tile.metrics.flood_risk-1,0,3)
		}
	
		//dam
		if just_completed(tile,MEASURE.DAM,finished_projects) {
			array_push(tile.implemented, MEASURE.DAM)	
			add_report(string("A dam has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
			tile.dammed = true
			tile.metrics.flood_risk = clamp(tile.metrics.flood_risk-2, 0,3)
			tile.metrics.drought_risk = clamp(tile.metrics.drought_risk+1, 0,4)
			var cur_tile = tile;
			var n_dammed = 0;
			var n_upstream = 0;
			//decrease flood risk and increase drought risk on downstream tiles (max of 5)
			while(get_downstream_tile(cur_tile) != noone and n_dammed < 5) {
				cur_tile.dammed = true
				cur_tile.metrics.flood_risk = clamp(cur_tile.metrics.flood_risk-2, 0,3)
				cur_tile.metrics.drought_risk = clamp(cur_tile.metrics.drought_risk+1, 0,4)
				cur_tile = get_downstream_tile(cur_tile)
				n_dammed++
			}
		}
	
		//nbs
		if just_completed(tile,MEASURE.NBS,finished_projects) {
			array_push(tile.implemented, MEASURE.NBS)	
			if tile.metrics.population <= 500 {
				tile.metrics.flood_risk = clamp(tile.metrics.flood_risk-1,0,3)	
			}
		}
	
		//ews flood
		if just_completed(tile,MEASURE.EWS_FLOOD,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_FLOOD)	
		}
	
		//ews cyclone
		if just_completed(tile,MEASURE.EWS_CYCLONE,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_CYCLONE)
		}
	
		//crops (normal/resistant)
		if just_completed(tile,MEASURE.NORMAL_CROPS,finished_projects) {
			tile.metrics.agriculture = 1
			global.map.crops_planted++
		}
		else if just_completed(tile,MEASURE.RESISTANT_CROPS,finished_projects) {
			tile.metrics.agriculture = 2
			global.map.crops_planted++
		}
		else {
			if tile.metrics.agriculture == -1 { tile.metrics.agriculture = 0 }
		}
	}
}

//matters related to population loss
function update_population_loss(finished_projects) {
	//set up starting populations for calculating amount of lives saved
	var starting_populations = ds_map_create();
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		starting_populations[? global.state.affected_tiles[i]] = get_population(tile)
	}
	//evacuate population from affected tiles
	var evacuateList = [];
	var evacuatedPopulation = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		if just_completed(_tile, MEASURE.EVACUATE, finished_projects) {
			array_push(evacuateList, _tile)	
		}
	}
	array_sort(global.state.affected_tiles, function(x1,x2) {
		//sort based on population, prioritize tiles with greatest population
		var t1 = tile_from_square(x1); var t2 = tile_from_square(x2);
		var p1 = get_population(t1);
		var p2 = get_population(t2);
		if p1 == p2 return 0
		else if p1 > p2 return -1
		else return 1
	}); 
	var curIndex = 0;
	for(var i=0; i<array_length(evacuateList); i++) {
		var toTile = evacuateList[i];
		var fromTile = tile_from_square(global.state.affected_tiles[curIndex]);
		curIndex++;
		if curIndex >= array_length(global.state.affected_tiles) curIndex = 0
		var disaster_multiplier = 1;
		if global.state.disaster == "drought" {
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.005
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.01
			if global.state.disaster_intensity == "high" disaster_multiplier = 0.05
		}
		if global.state.disaster == "flood" {
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.01
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.3
			if global.state.disaster_intensity == "high" disaster_multiplier = 0.7
		}
		if global.state.disaster == "cyclone" {
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.01
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.2
			if global.state.disaster_intensity == "high" disaster_multiplier = 0.7
		}
		
		var movePopulation = round(fromTile.metrics.population * disaster_multiplier * random_range(0.6, 0.9));
		movePopulation = clamp(movePopulation, 0, 500);
		evacuatedPopulation += movePopulation
		array_push(toTile.evacuated_population, {
			origin: coords_to_grid(fromTile.x,fromTile.y),
			population: movePopulation
		})
		fromTile.metrics.population -= movePopulation
		
		//move all pre-existing evacuated population to the other one
		for(var j = 0; j<array_length(fromTile.evacuated_population); j++) {
			var evac = fromTile.evacuated_population[j];
			array_push(toTile.evacuated_population, {
				origin: evac.origin,
				population: evac.population
			})
			evacuatedPopulation += evac.population
		}
		fromTile.evacuated_population = []
	}
	add_report(string("{0} citizens were evacuated to {1} cells",evacuatedPopulation*1000,array_length(evacuateList)))
	
	//population loss on tiles (deaths related to climate disasters)
	var total_population_lost = 0;
	var potential_population_lost = 0;
	var number_tiles_pop_lost = 0;
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		
		//dont know where else to put this
		if global.state.disaster == "flood" {
			tile.metrics.observed_flood = true	
		}
		else if global.state.disaster == "drought" {
			tile.metrics.observed_drought = true	
		}
		
		var loss_rate = 0;
		var base_loss_rate = 0;
		var high_agriculture_multiplier = 1;
		var less_agriculture_multiplier = 1.2;
		var low_agriculture_multiplier = 1.4;
		var critical_agriculture_multiplier = 1.6;
		
		var decrease_loss_rate = function(loss_rate, percent) {
			return loss_rate * (1 - (percent / 100))
		}
		
		switch(global.state.disaster) {
			case "flood":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0.0005,0.001) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.001,0.0025) }
				else { loss_rate = random_range(0.0025,0.01) }
				base_loss_rate = loss_rate
				
				if global.map.buildings_grid[tile.x div 64, tile.y div 64] == 2 {
					var mitigation_rate = random_range(20,30);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The flood-resistant buildings on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.EWS_FLOOD,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The flood EWS on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.DIKE,finished_projects) {
					var mitigation_rate = 0;
					switch(global.state.disaster_intensity) {
						case "low":
							 mitigation_rate = 100;
							break;
						case "medium":
							mitigation_rate = random_range(50,60);
							break;
						case "high":
							mitigation_rate = random_range(10,50);
							break;
					}
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The dike on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if tile.dammed {
					var mitigation_rate = random_range(60,80);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("Population loss on cell {0} was mitigated by {1}% due to a dam!",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				break;
				
			case "drought":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0,0.00025) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.00025,0.0005) }
				else { loss_rate = random_range(0.0005,0.002) }
				base_loss_rate = loss_rate
				
				high_agriculture_multiplier = 1.1;
				less_agriculture_multiplier = 1.4;
				low_agriculture_multiplier = 1.6;
				critical_agriculture_multiplier = 2;
				
				break;
				
			case "cyclone":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0,0.0005) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.0005,0.005) }
				else { loss_rate = random_range(0.005,0.01) }
				
				base_loss_rate = loss_rate
				
				if global.map.buildings_grid[tile.x div 64, tile.y div 64] == 3 {
					var mitigation_rate = random_range(20,30);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The cyclone-resistant buildings on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.EWS_CYCLONE,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The cyclone EWS on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.SEAWALL,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The seawall on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.NBS,finished_projects) {
					if tile.metrics.population > 500 {
						var mitigation_rate = random_range(10,20);
						loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
						add_report(string("The NBS on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					} else {
						var mitigation_rate = random_range(30,40);
						loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
						add_report(string("The NBS on cell {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
				}
				
				break;
		}
		
		//losses from unrepaired buildings
		if global.map.buildings_grid[tile.x div 64, tile.y div 64] == -1 and not is_implementing(tile,MEASURE.FLOOD_BUILDINGS) and not is_implementing(tile,MEASURE.CYCLONE_BUILDINGS) {
			loss_rate *= 2	
			base_loss_rate *= 2
		}
		
		//losses from hospital access
		var hospital_access = hospital_availability(tile);
		if hospital_access >= 1 {
			//nothing	
		} else if hospital_access > 0.75 {
			loss_rate *= 1.4
			base_loss_rate *= 1.4
		} else if hospital_access > 0.5 {
			loss_rate *= 1.6	
			base_loss_rate *= 1.6
		} else {
			loss_rate *= 2	
			base_loss_rate *= 2
		}
		
		//losses from agriculture access (crops)
		var agriculture_access = agricultural_availability(tile);
		if agriculture_access >= 1 {
			loss_rate *= high_agriculture_multiplier
		} else if agriculture_access > 0.75 {
			loss_rate *= less_agriculture_multiplier
			base_loss_rate *= less_agriculture_multiplier
		} else if agriculture_access > 0.5 {
			loss_rate *= low_agriculture_multiplier	
			base_loss_rate *= low_agriculture_multiplier
		} else {
			loss_rate *= critical_agriculture_multiplier
			base_loss_rate *= critical_agriculture_multiplier
		}
		
		var lost_population = round(tile.metrics.population * loss_rate);
		var lost_evacuated = round(get_evacuated_population(tile) * loss_rate);
		potential_population_lost += round(starting_populations[? global.state.affected_tiles[i]] * base_loss_rate);
		tile.metrics.population -= lost_population
		for(var j=0; j<array_length(tile.evacuated_population); j++) {
			tile.evacuated_population[j].population -= round(tile.evacuated_population[j].population * loss_rate)
		}
		if lost_population + lost_evacuated > 0 {
			total_population_lost += lost_population + lost_evacuated
			number_tiles_pop_lost += 1
		}
	}
	total_population_lost *= 1000
	potential_population_lost *= 1000
	global.map.deaths += floor(total_population_lost)
	global.map.lives_saved += floor(potential_population_lost - total_population_lost)
	var pop_string = string_format(total_population_lost, floor(log10(total_population_lost)), 0);
	add_report(string("A population of {0} people was lost over {1} cells due to the disaster.",pop_string,number_tiles_pop_lost))
	ds_map_destroy(starting_populations)
	
	var lost_population = 0;
	var lost_population_tiles = 0;
	//loop through non-affected tiles and remove population if there are damaged buildings
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];	
		if !array_contains(global.state.affected_tiles, coords_to_grid(tile.x,tile.y)) {
			if global.map.buildings_grid[tile.x div 64, tile.y div 64] == -1 and not is_implementing(tile,MEASURE.FLOOD_BUILDINGS) and not is_implementing(tile,MEASURE.CYCLONE_BUILDINGS) {
				// remove 20% of population from damaged buildings
				var loss_amt = round(tile.metrics.population * 0.2);
				lost_population += loss_amt * 1000
				lost_population_tiles++
				tile.metrics.population -= loss_amt
			}
		}
	}
	if lost_population > 0 {
		add_report(string("{0} people have moved out of the country due to unrepaired damaged buildings on {1} tile(s).",lost_population,lost_population_tiles))
	}
}