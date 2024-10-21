font = fSidebar
color = c_white

update = function() {
	text = string("Current date: {0}\n\n",date_date_string(global.state.datetime))
	if array_length(global.state.round_reports) > 0 {
		for(var i=0; i<array_length(global.state.round_reports); i++) {
			text += global.state.round_reports[i] + "\n"
		}
	} else {
		text += "Nothing happened since the last meeting!"	
	}
}

scale=1
h_align = fa_left