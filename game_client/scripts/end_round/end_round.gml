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
		if _tile.metrics.agriculture > 0 { n_remaining_agriculture++ }
		while array_length(_tile.measures) > 0 {
			var _measure = array_pop(_tile.measures);
			global.state.measures_implemented[_measure] += 1
			if _measure == MEASURE.AIRPORT {
				var pop = _tile.metrics.population;
				if pop > airport_pop { airport_pop = pop }
			}
			if _measure == MEASURE.EVACUATE { n_evacuate++ }
			if _measure == MEASURE.BUILDINGS { n_buildings++ }
			if _measure == MEASURE.NORMAL_CROPS || _measure == MEASURE.RESISTANT_CROPS { n_agriculture++ }
			var measure_struct = global.measures[? _measure];
			global.state.money_spent += measure_struct.cost
			var new_struct = {
				measure: _measure	
			};
			switch(measure_struct.time) {
				case "years":
					new_struct.days_remaining = round(365 * random_range(2,3)) // 3 years max? revisit this to make it project-dependent
					break;
				case "months":
					new_struct.days_remaining = round(30 * random_range(2,23)) // arbitrary
					break;
				case "weeks":
					new_struct.days_remaining = 1 // should always complete by next round
					break;
			}
			array_push(_tile.in_progress, new_struct)
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
		global.state.aid_objectives.buildings = false	
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
		
	//automatically finish all short-term projects 
	var finished_projects = progress_projects(1);
		
	//update map changes
	update_buildings(finished_projects)
	update_map_measures(finished_projects)
	update_population_loss(finished_projects)
		
	//go to the results screen
	global.state.current_phase = "results"
		
	if instance_exists(objOnline) {
		send_struct(MESSAGE.STATE, global.state) // update other players' state
	}
		
	room_goto(rRoundResults)
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
			struct.days_remaining -= days;
			if struct.days_remaining <= 0 {
				array_push(finished,{tile:tile,measure:struct.measure})
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

		if just_completed(_tile, MEASURE.BUILDINGS, finished_projects) {
			//repairing buildings that were damaged before
			global.map.buildings_grid[tx, ty] = 1
			add_report(string("Buildings in tile {0} were repaired.",coords_to_grid(tx,ty,false)))
		}
		if just_completed(_tile, MEASURE.HOSPITAL, finished_projects) {
			//repairing hospitals that were damaged before
			global.map.hospital_grid[tx, ty] = 1
			add_report(string("Hospital in tile {0} was repaired.",coords_to_grid(tx,ty,false)))
		}
		if just_completed(_tile, MEASURE.AIRPORT, finished_projects) {
			//repairing airports that were damaged before
			global.map.airport_grid[tx, ty] = 1
			add_report(string("Airport in tile {0} was repaired.",coords_to_grid(tx,ty,false)))
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
			add_report(string("A dike has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//seawall
		if just_completed(tile,MEASURE.SEAWALL,finished_projects) {
			array_push(tile.implemented, MEASURE.SEAWALL)	
			add_report(string("A seawall has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//dam
		if just_completed(tile,MEASURE.DAM,finished_projects) {
			array_push(tile.implemented, MEASURE.DAM)	
			add_report(string("A dam has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
			tile.dammed = true
			var cur_tile = tile;
			var n_dammed = 0;
			//decrease flood risk on downstream tiles (max of 3)
			while(get_downstream_tile(cur_tile) != noone and n_dammed < 3) {
				cur_tile.dammed = true
				cur_tile.metrics.flood_hazard = clamp(cur_tile.metrics.flood_hazard-1, 0,3)
				cur_tile = get_downstream_tile(cur_tile)
				n_dammed++
			}
			//increase flood risk on upstream tiles
			var upstream_tiles = get_upstream_tiles(tile);
			for(var t=0; t<array_length(upstream_tiles); t++) {
				var up_tile = upstream_tiles[t];
				up_tile.metrics.flood_hazard = clamp(up_tile.metrics.flood_hazard+1, 0,5)
			}
		}
	
		//nbs
		if just_completed(tile,MEASURE.NBS,finished_projects) {
			array_push(tile.implemented, MEASURE.NBS)	
			add_report(string("A nature-based solution has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//ews flood
		if just_completed(tile,MEASURE.EWS_FLOOD,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_FLOOD)	
			add_report(string("A flood EWS has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//ews cyclone
		if just_completed(tile,MEASURE.EWS_CYCLONE,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_CYCLONE)	
			add_report(string("A cyclone EWS has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//crops (normal/resistant)
		if just_completed(tile,MEASURE.NORMAL_CROPS,finished_projects) {
			tile.metrics.agriculture = 1
			add_report(string("Normal crops on tile {0} were planted.",coords_to_grid(tile.x,tile.y)))
		}
		else if just_completed(tile,MEASURE.RESISTANT_CROPS,finished_projects) {
			tile.metrics.agriculture = 2
			add_report(string("Drought-resistant crops on tile {0} were planted.",coords_to_grid(tile.x,tile.y)))
		}
		else {
			if tile.metrics.agriculture == -1 { tile.metrics.agriculture = 0 }
		}
	}
}

//matters related to population loss
function update_population_loss(finished_projects) {
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
		var p1 = t1.metrics.population;
		var p2 = t2.metrics.population;
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
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.02
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.1
			if global.state.disaster_intensity == "high" disaster_multiplier = 0.2
		}
		if global.state.disaster == "flood" {
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.1
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.5
			if global.state.disaster_intensity == "high" disaster_multiplier = 0.8
		}
		if global.state.disaster == "cyclone" {
			if global.state.disaster_intensity == "low" disaster_multiplier = 0.1
			if global.state.disaster_intensity == "medium" disaster_multiplier = 0.6
			if global.state.disaster_intensity == "high" disaster_multiplier = 1
		}
		var movePopulation = round(fromTile.metrics.population * disaster_multiplier * random_range(0.4, 0.8));
		movePopulation = clamp(movePopulation, 0, 200);
		evacuatedPopulation += movePopulation
		array_push(toTile.evacuated_population, {
			origin: coords_to_grid(fromTile.x,fromTile.y),
			population: movePopulation
		})
		fromTile.metrics.population -= movePopulation
	}
	add_report(string("{0} citizens were evacuated to {1} cells",evacuatedPopulation*1000,array_length(evacuateList)))
	
	//population loss on tiles (deaths related to climate disasters)
	//TODO: get more accurate estimates for loss rates
	var total_population_lost = 0;
	var number_tiles_pop_lost = 0;
	for(var i=0; i<array_length(global.state.affected_tiles); i++) {
		var tile = tile_from_square(global.state.affected_tiles[i]);
		var loss_rate = 0;
		var high_agriculture_multiplier = 1;
		var less_agriculture_multiplier = 1.2;
		var low_agriculture_multiplier = 1.4;
		var critical_agriculture_multiplier = 1.6;
		
		var decrease_loss_rate = function(loss_rate, percent) {
			return loss_rate * (1 - (percent / 100))
		}
		
		switch(global.state.disaster) {
			case "flood":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0.001,0.002) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.002,0.01) }
				else { loss_rate = random_range(0.01,0.025) }
				
				if has_implemented(tile,MEASURE.EWS_FLOOD,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The flood EWS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
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
					add_report(string("The dike on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if tile.dammed {
					var mitigation_rate = random_range(60,80);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("Population loss on tile {0} was mitigated by {1}% due to a dam!",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				break;
				
			case "drought":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0,0.0005) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.001,0.0025) }
				else { loss_rate = random_range(0.005,0.01) }
				
				high_agriculture_multiplier = 1.1;
				less_agriculture_multiplier = 1.4;
				low_agriculture_multiplier = 1.6;
				critical_agriculture_multiplier = 2;
				
				break;
				
			case "cyclone":
				if global.state.disaster_intensity == "low" { loss_rate = random_range(0.001,0.002) }
				else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.002,0.01) }
				else { loss_rate = random_range(0.01,0.05) }
				
				if has_implemented(tile,MEASURE.EWS_CYCLONE,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The cyclone EWS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.SEAWALL,finished_projects) {
					var mitigation_rate = random_range(40,50);
					loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
					add_report(string("The seawall on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
				}
				if has_implemented(tile,MEASURE.NBS,finished_projects) {
					if tile.metrics.population > 500 {
						var mitigation_rate = random_range(10,20);
						loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
						add_report(string("The NBS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					} else {
						var mitigation_rate = random_range(30,40);
						loss_rate = decrease_loss_rate(loss_rate, mitigation_rate)
						add_report(string("The NBS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
				}
				
				break;
		}
		
		//losses from hospital access
		var hospital_access = hospital_availability(tile);
		if hospital_access >= 1 {
			//nothing	
		} else if hospital_access > 0.75 {
			loss_rate *= 1.4
		} else if hospital_access > 0.5 {
			loss_rate *= 1.6	
		} else {
			loss_rate *= 2	
		}
		
		//losses from agriculture access (crops)
		var agriculture_access = agricultural_availability(tile);
		if agriculture_access >= 1 {
			loss_rate *= high_agriculture_multiplier
		} else if agriculture_access > 0.75 {
			loss_rate *= less_agriculture_multiplier
		} else if agriculture_access > 0.5 {
			loss_rate *= low_agriculture_multiplier	
		} else {
			loss_rate *= critical_agriculture_multiplier
		}
		
		var lost_population = round(tile.metrics.population * loss_rate);
		tile.metrics.population -= lost_population
		if lost_population > 0 {
			total_population_lost += lost_population
			number_tiles_pop_lost += 1
		}
	}
	total_population_lost *= 1000
	var pop_string = string_format(total_population_lost, floor(log10(total_population_lost)), 0);
	add_report(string("{0} total people died over {1} cells due to the disaster.",pop_string,number_tiles_pop_lost))
}