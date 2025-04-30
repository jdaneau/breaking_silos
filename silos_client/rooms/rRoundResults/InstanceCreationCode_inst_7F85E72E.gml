h_align = fa_left

update = function() {
	text = capitalize(global.state.disaster_intensity)
	if global.state.disaster_intensity == "low" {
		color = global.colors.light_blue	
	}
	if global.state.disaster_intensity == "medium" {
		color = global.colors.yellow	
	}
	if global.state.disaster_intensity == "high" {
		color = global.colors.magenta	
	}
}