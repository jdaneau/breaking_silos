manual_update = function() {
	var objectives = 0;
	if global.state.aid_objectives.agriculture objectives++
	if global.state.aid_objectives.buildings objectives++
	if global.state.aid_objectives.hospitals objectives++
	if global.state.aid_objectives.airport objectives++
	
	if objectives == 4 color = global.colors.light_green
	else color = global.colors.magenta
	
	text = string("{0} / 4",objectives) 
}

font = fMyriadBold20
h_align = fa_left
v_align = fa_top

manual_update()