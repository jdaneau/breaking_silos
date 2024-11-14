manual_update = function() {
	var agri = get_total_agriculture();
	if agri < global.map.starting_agriculture {
		color = c_red
		text = "(-" + string(global.map.starting_agriculture-agri) + " from starting value)"
	}
	else {
		color = c_lime
		text = "(+" + string(agri-global.map.starting_agriculture) + " from starting value)"
	}
}
font = fTooltipBold
manual_update()