function get_map_changes(){
	var orig_map = global.maps[? rMap01];
	if objOnline.lobby_settings.landscape_type == "Coastal" orig_map = global.maps[? rMap02]
	else if objOnline.lobby_settings.landscape_type == "Continental" orig_map = global.maps[? rMap03]
	
	var changes = [];
	
	//tile differences
	for(var i=0; i<array_length(orig_map.land_tiles); i++) {
		var orig_tile = orig_map.land_tiles[i];
		var tx = orig_tile.x div 64;
		var ty = orig_tily.y div 64;
		var new_tile = tile_from_coords(tx,ty);
		if !struct_equals(orig_tile,new_tile) {
			array_push(changes, {
				type: "tile",
				x: tx,
				y: ty,
				metrics: new_tile.metrics,
				measures: new_tile.measures,
				in_progress: new_tile.in_progress,
				implemented: new_tile.implemented,
				evacuated_population: new_tile.evacuated_population,
				dammed: new_tile.dammed
			})
		}
	}
	
	//everything else (always included)
	array_push(changes, {
		type: "buildings",
		buildings_grid: global.map.buildings_grid
	})
	array_push(changes, {
		type: "hospitals",
		hospital_grid: global.map.hospital_grid
	})
	array_push(changes, {
		type: "airports",
		airport_grid: global.map.airport_grid
	})
	
	array_push(changes, {
		type: "stats",
		hospitals_repaired: global.map.hospitals_repaired,
		airports_repaired: global.map.airports_repaired,
		crops_planted: global.map.crops_planted,
		deaths: global.map.deaths,
		lives_saved: global.map.lives_saved,
		money_spent: global.map.money_spent,
		measures_implemented: global.map.measures_implemented,
	})
	
	return changes
}