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
				var new_struct = {
					measure: _measure	
				};
				switch(measure_struct.time) {
					case "years":
						new_struct.days_remaining = 365 * random_range(2,3) // 3 years max? revisit this to make it project-dependent
						break;
					case "months":
						new_struct.days_remaining = 30 * irandom_range(2,23) // arbitrary
						break;
					case "weeks":
						new_struct.days_remaining = 1 // should always complete by next round
						break;
				}
				array_push(_tile.in_progress, new_struct)
			}
		}
		
		//automatically finish all short-term projects 
		var finished_projects = progressProjects(1);
		
		//update map changes
		addReport("Shortly following the meeting: ")
		updateBuildings(finished_projects)
		updateMapMeasures(finished_projects)
		updatePopulation(finished_projects)
		
		//generate next disaster
		global.state.next_disaster = get_next_disaster();
		var days = global.state.next_disaster.days_since_last_disaster;
		global.state.disaster = global.state.next_disaster.disaster
		
		//progress all projects and get a list of finished ones
		finished_projects = progressProjects(days);
		
		//update map changes
		addReport("\nUp till now: ")
		updateBuildings(finished_projects,true)
		updateMapMeasures(finished_projects,true)
		updatePopulation(finished_projects,true)
		
		room_goto(rRoundResults)
	}
}

// adds a report to the list of messages to show at the end of the round
function addReport(msg) {
	array_push(global.state.round_reports, msg)
}

// progresses all the projects in each tile and also returns a list of the ones that were finished
function progressProjects(days) {
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
function updateBuildings(finished_projects, future=false) {
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		var tx = _tile.x div 64;
		var ty = _tile.y div 64;
		//handle buildings being repaired on affected tiles
		if !future and array_contains(global.state.affected_tiles, coords_to_grid(_tile.x,_tile.y)) {
			if just_completed(_tile, MEASURE.BUILDINGS, finished_projects) {
				//repair buildings on same round - nothing happens
			} else {
				//didn't repair buildings, set them to damaged for floods and cyclones
				if global.state.disaster == "cyclone" or global.state.disaster == "flood" {
					global.map.buildings_grid[tx, ty] = -1	
					addReport(string("Buildings in tile {0} were damaged by the disaster.",coords_to_grid(tx,ty,false)))
				}
			}
			
			if just_completed(_tile, MEASURE.HOSPITAL, finished_projects) {
				//repair hospital on same round - nothing happens
			} else if global.map.hospital_grid[tx,ty] == 1 {
				//set hospitals to damaged if not repaired
				if (global.state.disaster == "cyclone" or global.state.disaster == "flood") and global.state.disaster_intensity != "low" {
					global.map.hospital_grid[tx,ty] = -1
					addReport(string("The hospital in tile {0} was damaged by the disaster.",coords_to_grid(tx,ty,false)))
				}
			}
			
			if just_completed(_tile, MEASURE.AIRPORT, finished_projects) {
				//repair airport on same round - nothing happens
			} else if global.map.airport_grid[tx,ty] == 1 {
				//set airports to damaged if not repaired
				if (global.state.disaster == "cyclone" or global.state.disaster == "flood") and global.state.disaster_intensity != "low" {
					global.map.airport_grid[tx,ty] = -1
					addReport(string("The airport in tile {0} was damaged by the disaster.",coords_to_grid(tx,ty,false)))
				}
			}
		}
		//handle buildings that are built on other tiles
		else {
			if just_completed(_tile, MEASURE.BUILDINGS, finished_projects) {
				//repairing buildings that were damaged before
				global.map.buildings_grid[tx, ty] = 1
				addReport(string("Buildings in tile {0} were repaired.",coords_to_grid(tx,ty,false)))
			}
			if just_completed(_tile, MEASURE.HOSPITAL, finished_projects) {
				//repairing hospitals that were damaged before
				global.map.hospital_grid[tx, ty] = 1
				addReport(string("Hospital in tile {0} was repaired.",coords_to_grid(tx,ty,false)))
			}
			if just_completed(_tile, MEASURE.AIRPORT, finished_projects) {
				//repairing airports that were damaged before
				global.map.airport_grid[tx, ty] = 1
				addReport(string("Airport in tile {0} was repaired.",coords_to_grid(tx,ty,false)))
			}
		}
	}
}

// update all other measure types
function updateMapMeasures(finished_projects, future=false) {
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		
		//dike
		if just_completed(tile,MEASURE.DIKE,finished_projects) {
			array_push(tile.implemented, MEASURE.DIKE)	
			addReport(string("A dike has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//seawall
		if just_completed(tile,MEASURE.SEAWALL,finished_projects) {
			array_push(tile.implemented, MEASURE.SEAWALL)	
			addReport(string("A seawall has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//dam
		var get_downstream_tile = function(_tile) {
			var tx = _tile.x div 64; 
			var ty = _tile.y div 64;
			switch (global.map.river_flow_grid[tx,ty]) {
				case "up":
					if river_flow_grid[tx,ty-1] != "" { return tile_from_coords(tx,ty-1) }
					break;
				case "down":
					if river_flow_grid[tx,ty+1] != "" { return tile_from_coords(tx,ty+1) }
					break;
				case "left":
					if river_flow_grid[tx-1,ty] != "" { return tile_from_coords(tx-1,ty) }
					break;
				case "right":
					if river_flow_grid[tx+1,ty] != "" { return tile_from_coords(tx+1,ty) }
					break;
				default:
					return noone;
			}
			return noone;
		}
		if just_completed(tile,MEASURE.DAM,finished_projects) {
			array_push(tile.implemented, MEASURE.DAM)	
			addReport(string("A dam has completed construction on tile {0}.",coords_to_grid(tile.x,tile.y)))
			tile.dammed = true
			var cur_tile = tile;
			while(get_downstream_tile(cur_tile) != noone) {
				cur_tile.dammed = true
				cur_tile = get_downstream_tile(cur_tile)
			}
		}
	
		//nbs
		if just_completed(tile,MEASURE.NBS,finished_projects) {
			array_push(tile.implemented, MEASURE.NBS)	
			addReport(string("A nature-based solution has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//ews flood
		if just_completed(tile,MEASURE.EWS_FLOOD,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_FLOOD)	
			addReport(string("A flood EWS has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//ews cyclone
		if just_completed(tile,MEASURE.EWS_CYCLONE,finished_projects) {
			array_push(tile.implemented, MEASURE.EWS_CYCLONE)	
			addReport(string("A cyclone EWS has been implemented on tile {0}.",coords_to_grid(tile.x,tile.y)))
		}
	
		//crops (normal/resistant)
		//damages to existing crops
		if !future and array_contains(global.state.affected_tiles, coords_to_grid(tile.x,tile.y)) {
			if tile.metrics.agriculture == 1 { // regular crops
				if not (global.state.disaster=="flood" and global.state.disaster_intensity=="low") {
					tile.metrics.agriculture = 0	
					addReport(string("Crops on tile {0} were destroyed.",coords_to_grid(tile.x,tile.y)))
				}
			}
			else if tile.metrics.agriculture == 2 { // drought-resistant crops
				if global.state.disaster != "drought" {
					tile.metrics.agriculture = 0
					addReport(string("Crops on tile {0} were destroyed.",coords_to_grid(tile.x,tile.y)))
				}
			}
		}
		//plant new crops
		else {
			if just_completed(tile,MEASURE.NORMAL_CROPS,finished_projects) {
				tile.metrics.agriculture = 1
				addReport(string("Normal crops on tile {0} were planted.",coords_to_grid(tile.x,tile.y)))
			}
			else if just_completed(tile,MEASURE.RESISTANT_CROPS,finished_projects) {
				tile.metrics.agriculture = 2
				addReport(string("Drought-resistant crops on tile {0} were planted.",coords_to_grid(tile.x,tile.y)))
			}
		}
	}
}

// update all matters relating to population gain/loss
function updatePopulation(finished_projects, future=false) {
	//population update related to current disaster (evacuation / deaths)
	if (!future) {
		for(var i=0; i<array_length(global.map.land_tiles); i++) {
			var tile = global.map.land_tiles[i];
			while(array_length(tile.evacuated_population) > 0) {
				var struct = array_pop(tile.evacuated_population);
				var targetTile = tile_from_square(struct.origin);
				targetTile.metrics.population += struct.population;
			}
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
		var tilesToEvacuate array_sort(global.state.affected_tiles, function(x1,x2) {
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
			var fromTile = tile_from_square(tilesToEvacuate[curIndex]);
			curIndex++;
			var movePopulation = clamp(fromTile.metrics.population / 50, 0, 10);
			evacuatedPopulation += movePopulation
			array_push(toTile.evacuated_population, {
				origin: coords_to_grid(fromTile.x,fromTile.y),
				population: movePopulation
			})
			fromTile.metrics.population -= movePopulation
		}
		addReport(string("{0} citizens were evacuated to {1} cells",evacuatedPopulation*1000,array_length(evacuateList)))
	
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
		
			var decrease_risk = function(loss_rate, percent) {
				return loss_rate * (1 - (percent / 100))
			}
		
			switch(global.state.disaster) {
				case "flood":
					if global.state.disaster_intensity == "low" { loss_rate = random_range(0.001,0.005) }
					else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.005,0.02) }
					else { loss_rate = random_range(0.02,0.1) }
				
					if has_implemented(tile,MEASURE.EWS_FLOOD,finished_projects) {
						var mitigation_rate = random_range(40,50);
						loss_rate = decrease_risk(loss_rate, mitigation_rate)
						addReport(string("The flood EWS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
					if has_implemented(tile,MEASURE.DIKE,finished_projects) {
						var mitigation_rate = random_range(50,60);
						loss_rate = decrease_risk(loss_rate, mitigation_rate)
						addReport(string("The dike on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
					if tile.dammed {
						var mitigation_rate = random_range(60,80);
						loss_rate = decrease_risk(loss_rate, mitigation_rate)
						addReport(string("Population loss on tile {0} was mitigated by {1}% due to a dam!",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
					break;
				
				case "drought":
					if global.state.disaster_intensity == "low" { loss_rate = random_range(0.001,0.005) }
					else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.005,0.02) }
					else { loss_rate = random_range(0.02,0.05) }
				
					high_agriculture_multiplier = 1.1;
					less_agriculture_multiplier = 1.4;
					low_agriculture_multiplier = 1.6;
					critical_agriculture_multiplier = 2;
				
					break;
				
				case "cyclone":
					if global.state.disaster_intensity == "low" { loss_rate = random_range(0.001,0.005) }
					else if global.state.disaster_intensity == "medium" { loss_rate = random_range(0.005,0.03) }
					else { loss_rate = random_range(0.03,0.1) }
				
					if has_implemented(tile,MEASURE.EWS_CYCLONE,finished_projects) {
						var mitigation_rate = random_range(40,50);
						loss_rate = decrease_risk(loss_rate, mitigation_rate)
						addReport(string("The cyclone EWS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
					if has_implemented(tile,MEASURE.SEAWALL,finished_projects) {
						var mitigation_rate = random_range(40,50);
						loss_rate = decrease_risk(loss_rate, mitigation_rate)
						addReport(string("The seawall on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
					}
					if has_implemented(tile,MEASURE.NBS,finished_projects) {
						if tile.metrics.population > 500 {
							var mitigation_rate = random_range(10,20);
							loss_rate = decrease_risk(loss_rate, mitigation_rate)
							addReport(string("The NBS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
						} else {
							var mitigation_rate = random_range(30,40);
							loss_rate = decrease_risk(loss_rate, mitigation_rate)
							addReport(string("The NBS on tile {0} mitigated population loss by {1}% !",coords_to_grid(tile.x,tile.y),round(mitigation_rate)))
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
		
			var lost_population = tile.metrics.population * loss_rate;
			tile.metrics.population -= lost_population
			if lost_population > 0 {
				total_population_lost += lost_population
				number_tiles_pop_lost += 1
			}
		}
		addReport(string("{0} total people died over {1} cells due to the disaster.",total_population_lost*1000,number_tiles_pop_lost))
	}
	else {
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
}