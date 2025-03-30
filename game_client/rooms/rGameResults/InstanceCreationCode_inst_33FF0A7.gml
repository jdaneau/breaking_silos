font = fChat
color = c_white
scale = 1
v_align = fa_top
h_align = fa_left
manual_update = function() {
	var years = date_year_span(date_current_datetime(), global.state.datetime);
	text = string("Here is what your team accomplished over {0} years:\n\n",years)

	var n_dammed = 0;
	var n_dikes = 0;
	var n_ews = 0;
	var n_nbs = 0;
	var n_seawalls = 0;
	for(var i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		if tile.dammed { n_dammed++ }
		if has_implemented(tile,MEASURE.DIKE,[]) n_dikes++
		if has_implemented(tile,MEASURE.EWS_CYCLONE,[]) or has_implemented(tile,MEASURE.EWS_FLOOD,[]) n_ews++
		if has_implemented(tile,MEASURE.NBS,[]) n_nbs++
		if has_implemented(tile,MEASURE.SEAWALL,[]) n_seawalls++
	}
	text += string("Number of measures implemented: {0}\n",global.map.measures_implemented)
	if n_dammed > 0 text += string("Number of dammed tiles: {0}\n",n_dammed)
	if n_dikes > 0 text += string("Number of dikes constructed: {0}\n",n_dikes)
	if n_ews > 0 text += string("Early Warning Systems (EWS) implemented: {0}\n",n_ews)
	if n_nbs > 0 text += string("Nature-based Solutions (NBS) implemented: {0}\n",n_nbs)
	if n_seawalls > 0 text += string("Seawalls constructed: {0}\n",n_seawalls)
	text += string("Hospitals reconstructed: {0}\n",global.map.hospitals_repaired)
	text += string("Airports reconstructed: {0}\n",global.map.airports_repaired)
	text += string("Crops planted: {0}\n",global.map.crops_planted)

	text += string("\nTotal population loss: {0}\n",global.map.deaths)
	text += string("Estimated population saved: {0}\n",global.map.lives_saved)
	text += string("Total money spent: {0} coins\n\n",global.map.money_spent)
	
	var old_map;
	switch(objOnline.lobby_settings.landscape_type) {
		case "Island":
			old_map = global.maps[? rMap01]
		break;
		case "Coastal":
			old_map = global.maps[? rMap02]
		break;
		case "Continental":
			old_map = global.maps[? rMap03]
		break;
	}
	
	text += "Here is the state of the country compared to the start of the game:\n\n"
	var old_pop = 0;
	var old_flood_risk = 0;
	var old_drought_risk = 0;
	var old_cyclone_risk = 0;
	var old_agriculture = global.map.starting_agriculture;
	for(var t=0; t<array_length(old_map.land_tiles); t++) {
		var tile = old_map.land_tiles[t];
		old_pop += tile.metrics.population * 1000
		old_flood_risk += tile.metrics.flood_risk
		old_drought_risk += tile.metrics.drought_risk
		old_cyclone_risk += tile.metrics.cyclone_risk
	}
	var new_pop = get_total_population();
	var new_flood_risk = get_total_risk("flood");
	var new_cyclone_risk = get_total_risk("cyclone");
	var new_drought_risk = get_total_risk("drought");
	var new_agriculture = get_total_agriculture();
	
	var n_damaged_buildings = get_n_damaged_cells();
	var n_damaged_hospitals = get_n_damaged_hospitals();
	var n_damaged_airports = get_n_damaged_airports();
	var evacuated_population = new_pop - get_total_population("raw",false);
	
	text += string("Population: {0} (Originally {1})\n",new_pop,old_pop)
	text += string("Agricultural cells: {0} (Originally {1})\n",new_agriculture, old_agriculture)
	text += string("Total flood hazard across all cells: {0} (Originally {1})\n",new_flood_risk,old_flood_risk)
	text += string("Total drought hazard across all cells: {0} (Originally {1})\n",new_drought_risk,old_drought_risk)
	text += string("Total cyclone hazard across all cells: {0} (Originally {1})\n",new_cyclone_risk,old_cyclone_risk)
	text += string("Cells left with damaged buildings: {0}\n",n_damaged_buildings)
	text += string("Cells left with damaged hospitals: {0}\n",n_damaged_hospitals)
	text += string("Cells left with damaged airports: {0}\n",n_damaged_airports)
	text += string("Evacuated population left in temporary shelters: {0}",evacuated_population)
}
manual_update()
