manual_update = function() {
	var pop = get_total_population();
	var start_pop = global.state.starting_population * 1000;
	if pop < start_pop {
		color = c_red
		text = "(-" + string(start_pop-pop) + " from starting value)"
	}
	else {
		color = c_lime
		text = "(+" + string(pop-start_pop) + " from starting value)"
	}
}
font = fTooltipBold
manual_update()