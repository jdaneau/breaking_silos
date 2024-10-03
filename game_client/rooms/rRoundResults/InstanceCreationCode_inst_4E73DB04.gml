font = fTooltipBold
color = c_white
h_align = fa_right
v_align = fa_top
scale=1

if aid_conditions_met() {
	text = "+ 5000 coins"
}
else {
	h_align = fa_left
	x += 32
	text = "\nTo receive aid next time:\n\n"
	if !global.state.aid_objectives.buildings {
		text += "- Repair or evacuate every affected cell\n\n"
	}
	if !global.state.aid_objectives.hospitals {
		text += "- Repair every damaged hospital\n\n"
	}
	if !global.state.aid_objectives.airport {
		text += "- Repair the airport with the highest cell population\n\n"
	}
	if !global.state.aid_objectives.agriculture {
		text += string("- Ensure the number of agricultural cells is equal or more than the starting amount ({0})\n",global.map.starting_agriculture)
	}
}