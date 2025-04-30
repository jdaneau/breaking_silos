h_align = fa_left
font = fMyriad12

text = "CELLS WITH DAMAGED BUILDINGS"

manual_update = function() {
	var n_damaged = get_n_damaged_cells();
	if n_damaged > 0 {
		color = global.colors.magenta	
	} else color = global.colors.light_green	
}
manual_update()