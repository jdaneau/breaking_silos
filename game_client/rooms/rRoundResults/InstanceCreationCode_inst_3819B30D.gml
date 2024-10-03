font = fSidebar
color = c_white
h_align = fa_right
v_align = fa_top

if aid_conditions_met() {
	text = "International aid received!"
}
else {
	h_align = fa_center
	text = "No international aid :("	
}
scale=1