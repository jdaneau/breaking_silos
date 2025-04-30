font = fMyriad14
update = function() {
	text = "Agricultural tiles to be lost: " + string(global.state.n_agriculture_lost)	
	if global.state.n_agriculture_lost > 0 {
		color = global.colors.magenta_50
	} else color = global.colors.dark_blue_25
}