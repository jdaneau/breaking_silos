font = fMyriad14
color = c_white
h_align = fa_left
v_align = fa_top

manual_update = function() {
	text =  string("In the direct aftermath of the {0}:\n\n",global.state.disaster)
	var total_mitigation = 1;
	var mitigation_count = 0;
	for(var i=0; i<array_length(global.state.round_reports); i++) {
		text += global.state.round_reports[i] + "\n"
	}
}
manual_update()