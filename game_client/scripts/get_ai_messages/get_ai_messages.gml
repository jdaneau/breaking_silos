function get_ai_messages(){
	var messages = [];
	var all_roles = ds_map_keys_to_array(global.roles);
	var player_roles = ds_map_values_to_array(objOnline.players);
	var ai_roles = [];
	for(var i=0; i<array_length(all_roles); i++) {
		if !array_contains(player_roles, all_roles[i]) array_push(ai_roles, all_roles[i])
	}
	
	for(var i=0; i<array_length(ai_roles); i++) {
		var cur_role = ai_roles[i];
		var affected_tiles = [];
		for(var j=0; j<array_length(global.state.affected_tiles); j++) {
			array_push(affected_tiles, tile_from_square(global.state.affected_tiles[j]))	
		}
		switch(cur_role) {
			case ROLE.AGRICULTURE:
				var n_normal = 0;
				var n_resistant = 0;
				var lost_crops = false;
				for(var t=0; t<array_length(affected_tiles); t++) {
					var tile = affected_tiles[t];
					var flood_risk = tile.metrics.flood_risk;
					var drought_risk = tile.metrics.drought_risk;
					if tile.metrics.agriculture == -1 {
						lost_crops = true
						if drought_risk > flood_risk n_resistant++ else n_normal++
					}
				}
				if lost_crops {
					if n_resistant > n_normal {
						array_push(messages, "Agricultural Representative: 'Looks like some crops were damaged by the disaster. This area is pretty drought-prone, so maybe we should plant some drought-resistant crops.'")
					} else {
						array_push(messages, "Agricultural Representative: 'Looks like some crops were damaged by the disaster. We should plant some normal crops to replenish the country's agriculture needs.'")
					}
				} else {
					var diff = global.map.starting_agriculture - get_total_agriculture();
					if diff > 0 {
						array_push(messages, "Agricultural Representative: 'There weren't any crops damaged by this disaster, but we still have an agricultural deficit in the country. We need to plant more crops.'")	
					}
				}
			break;
			case ROLE.CITIZEN:
				var mode = choose("drought","flood");
				var tiles = array_shuffle(global.map.land_tiles);	
				if mode == "flood" {
					var watch_measures = [MEASURE.EWS_FLOOD, MEASURE.DIKE, MEASURE.NBS, MEASURE.SEAWALL];
					for(var t=0; t<array_length(tiles); t++) {
						var tile = tiles[t];
						if tile.metrics.observed_flood {
							var msg = true;
							for(var m=0; m<array_length(watch_measures); m++) {
								if is_implementing(tile,watch_measures[m]) or array_contains(tile.implemented,watch_measures[m]) {
									msg = false
								}
							}
							if msg {
								var square = coords_to_grid(t.x,t.y);
								array_push(messages, string("Citizen Representative: 'The people around cell {0} are complaining that nothing has been done to protect them against floods. I recommend implementing NBS to help them out.'",square))
								break;
							}
							else if t == array_length(tiles)-1 {
								array_push(messages, "Citizen Representative: 'You've done a good job protecting the flood-vulnerable population. I would still recommend implementing NBS on some cells for more flood protection.'")
							}
						}
					}
				}
				else if mode == "drought" {
					for(var t=0; t<array_length(tiles); t++) {
						var tile = tiles[t];
						if tile.metrics.observed_drought {
							if tile.metrics.agriculture <= 0 and !is_implementing(tile,MEASURE.NORMAL_CROPS) and !is_implementing(tile,MEASURE.RESISTANT_CROPS) {
								var square = coords_to_grid(t.x,t.y);
								array_push(messages, string("Citizen Representative: 'The people around cell {0} are complaining that nothing has been done to protect them against droughts. I recommend planting drought-resistant crops in the area.'",square))
								break;
							}
							else if t == array_length(tiles)-1 {
								array_push(messages, "Citizen Representative: 'You've done a good job protecting the drought-vulnerable population. I would still recommend planting drought-resistant crops to protect people in vulnerable areas.'")
							}
						}
					}
				}
			break;
			case ROLE.ENGINEER:
				var mode = choose("dam","seawall");
				if objOnline.lobby_settings.landscape_type == "Continental" { mode = "dam" }
				var tiles = array_shuffle(global.map.land_tiles);	
				if mode == "dam" {
					var building_dam = false;
					for(var t=0; t<array_length(tiles); t++) {
						if is_implementing(tiles[t],MEASURE.DAM) building_dam = true	
					}
					if !building_dam {
						array_push(messages, "Engineer: 'I recommend building a dam along one of the bigger rivers to protect against floods. This will help us control the amount of water in our rivers and harness energy for our population.'")
					} else {
						array_push(messages, "Engineer: 'Nice to see we're building a dam. Make sure that area is protected from hazards so we can avoid losing out on construction time!'")
					}
				}
				else {
					var msg = false;
					for(var t=0; t<array_length(tiles); t++) {
						var tile = tiles[t];
						if is_coastal(tile.x div 64, tile.y div 64) and !is_implementing(tile,MEASURE.SEAWALL) and !array_contains(tile.implemented,MEASURE.SEAWALL) {
							if tile.metrics.flood_risk == 3 || (tile.metrics.flood_risk == 2 and tile.metrics.population >= 700) {
								var square = coords_to_grid(tile.x,tile.y);
								array_push(messages, string("Engineer: 'The coastal region around cell {0} seems to be quite flood-prone. I recommend building seawalls to help prevent major damages.'",square))
								msg = true
								break;
							}
						}
					}
					if !msg {
						array_push(messages, "Engineer: 'All our coastal regions seem to be well protected with seawalls.'")
					}
				}
			break;
			case ROLE.FINANCE:
				var money = 0;
				var airport = false;
				for(var t=0; t<array_length(affected_tiles); t++) {
					var tile = affected_tiles[t];
					var tx = tile.x div 64; var ty = tile.y div 64;
					if global.map.buildings_grid[tx,ty] == -1 {
						money += global.measures[MEASURE.BUILDINGS].cost	
					} else {
						money += global.measures[MEASURE.EVACUATE].cost	
					}
					if tile.metrics.agriculture == -1 {
						money += global.measures[MEASURE.NORMAL_CROPS].cost	
					}
					if global.map.hospital_grid[tx,ty] == -1 {
						money += global.measures[MEASURE.HOSPITAL].cost	
					}
					if global.map.airport_grid[tx,ty] == -1 and !airport {
						money += global.measures[MEASURE.AIRPORT].cost	
						airport = true
					}
				}
				array_push(messages, string("Finance Minister: 'I estimate that we would have to spend at least {0} coins this round to properly address the disaster.'",money))
			break;
			case ROLE.FLOOD:
			
			break;
			case ROLE.HOUSING:
			
			break;
			case ROLE.INTERNATIONAL:
			
			break;
		}
	}
}