manual_update = function() {
	var adding = get_n_implementing(MEASURE.BUILDINGS) + get_n_implementing(MEASURE.FLOOD_BUILDINGS) + get_n_implementing(MEASURE.CYCLONE_BUILDINGS);
	if adding > 0 {
		text = string("({0} being repaired)",adding)
	}
}
manual_update()

font = fMyriad12
color = global.colors.light_green
h_align = fa_left