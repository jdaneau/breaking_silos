font = fMyriad16
color = c_white
h_align = fa_left
v_align = fa_top

manual_update = function() {
	if aid_conditions_met() {
		text = "International aid received!"
	}
	else {
		text = "No international aid :("	
	}
}
scale=1

manual_update()