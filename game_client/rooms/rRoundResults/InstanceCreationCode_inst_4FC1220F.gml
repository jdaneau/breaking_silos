manual_update = function() {
	var pop = get_total_population();
	var start_pop = global.state.starting_population * 1000;
	if pop < start_pop {
		color = global.colors.magenta
		text = "(-" + string(start_pop-pop) + " from starting value)"
	}
	else {
		color = global.colors.light_green
		text = "(+" + string(pop-start_pop) + " from starting value)"
	}
}
font = fMyriad12
manual_update()

h_align = fa_left