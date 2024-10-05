font = fSidebar
color = c_white

update = function() {
	text = "In the time since the last meeting:\n\n"
	if array_length(global.state.round_reports) > 0 {
		for(var i=0; i<array_length(global.state.round_reports); i++) {
			text += global.state.round_reports[i] + "\n"
		}
	} else {
		text += "Nothing happened!"	
	}
}

scale=1
h_align = fa_left