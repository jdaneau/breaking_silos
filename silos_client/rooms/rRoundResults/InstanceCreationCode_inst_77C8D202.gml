font = fMyriad14
update = function() {
	text = "Hospitals to be damaged: " + string(global.state.n_hospitals_damaged)	
	if global.state.n_hospitals_damaged > 0 {
		color = global.colors.magenta_50
	} else color = global.colors.dark_blue_25
}