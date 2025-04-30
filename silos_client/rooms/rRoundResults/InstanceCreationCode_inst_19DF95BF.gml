font = fMyriad14
update = function() {
	text = "Projects to be interrupted: " + string(global.state.n_projects_interrupted)
	if global.state.n_projects_interrupted > 0 {
		color = global.colors.magenta_50
	} else color = global.colors.dark_blue_25
}