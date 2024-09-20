font = fTooltip
color = c_white

text = ""
for(var i=0; i<array_length(global.state.round_reports); i++) {
	text += global.state.round_reports[i] + "\n"
}

scale=1