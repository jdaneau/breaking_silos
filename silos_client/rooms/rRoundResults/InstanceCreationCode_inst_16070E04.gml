manual_update = function() {
	var n_damaged = get_n_damaged_cells();
	text = string(n_damaged)
	if n_damaged > 0 {
		color = global.colors.magenta	
	} else color = global.colors.light_green
}
manual_update()

font = fMyriadBold20
h_align = fa_left