manual_update = function() {
	var target_agri = get_minimum_agriculture();
	var agri = get_total_agriculture();
	if agri < target_agri {
		color = global.colors.magenta
	}
	else {
		color = global.colors.light_green
	}
	text = string("({0} minimum needed to feed population)",target_agri)
}
font = fMyriad12
h_align = fa_left
v_align = fa_middle

manual_update()