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
			
			break;
			case ROLE.ENGINEER:
			
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