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
	text += string("Estimated lives saved: {0}\n",global.map.lives_saved)
	text += string("Total money spent: {0} coins\n",global.map.money_spent)
}
