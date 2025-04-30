color = c_white
font = fMyriad12
h_align = fa_left

manual_update = function() {
	var adding = get_n_implementing(MEASURE.NORMAL_CROPS) + get_n_implementing(MEASURE.RESISTANT_CROPS);
	if adding > 0 {
		text = string("\n({0} in-progress)",adding)
	}
}

manual_update()