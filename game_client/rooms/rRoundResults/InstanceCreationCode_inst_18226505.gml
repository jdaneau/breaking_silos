color = c_white

manual_update = function() {
	text = "Current agriculture:\n" + string(get_total_agriculture()) + " cells"
	var adding = get_n_implementing(MEASURE.NORMAL_CROPS) + get_n_implementing(MEASURE.RESISTANT_CROPS);
	if adding > 0 {
		text += string("\n({0} in-progress)",adding)
	}
}

manual_update()