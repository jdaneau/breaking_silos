text = "MAIN AIRPORT"
font = fMyriad16
h_align = fa_left
v_align = fa_middle

manual_update = function() {
	if global.state.aid_objectives.airport color = global.colors.light_green
	else color=global.colors.dark_blue_25
}

manual_update()