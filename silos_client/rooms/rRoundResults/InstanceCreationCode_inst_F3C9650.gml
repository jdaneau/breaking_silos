h_align = fa_left

update = function() {
	text = capitalize(global.state.disaster)
	if global.state.disaster == "flood" {
		color = global.colors.light_blue	
	}
	if global.state.disaster == "drought" {
		color = global.colors.yellow	
	}
	if global.state.disaster == "cyclone" {
		color = global.colors.magenta	
		text = "Tropical Cyclone"
	}
}

font = fMyriad16