font = fMyriad14
update = function() {
	text = "Cells to have buildings damaged: " + string(global.state.n_tiles_damaged)	
	if global.state.n_tiles_damaged > 0 {
		color = global.colors.magenta_50
	} else color = global.colors.dark_blue_25
}