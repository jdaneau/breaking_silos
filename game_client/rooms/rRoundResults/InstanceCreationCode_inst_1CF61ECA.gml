manual_update = function() {
	var target_agri = get_minimum_agriculture();
	var agri = get_total_agriculture();
	if agri < target_agri {
		color = c_red
	}
	else {
		color = c_lime
	}
	text = string("({0} minimum needed to feed population)",target_agri)
}
font = fTooltipBold
manual_update()