font = fMyriadBold16
color = c_white
h_align = fa_left
v_align = fa_top
scale=1

manual_update = function() {
	if aid_conditions_met() {
		text = "+ 5000 coins"
	}
	else {
		font = fMyriad14
		color = global.colors.dark_blue_25
		text = "To receive aid next time:\n\n"
		if !global.state.aid_objectives.buildings {
			text += "> Repair or evacuate every affected cell\n\n"
		}
		if !global.state.aid_objectives.hospitals {
			text += "> Repair every damaged hospital\n\n"
		}
		if !global.state.aid_objectives.airport {
			text += "> Repair the airport with the highest cell population\n\n"
		}
		if !global.state.aid_objectives.agriculture {
			text += string("> Ensure the number of agricultural cells is equal or more than the required amount ({0})\n",get_minimum_agriculture())
		}
	}
}

manual_update()