font = fSidebar
color = c_white

text = "Measures implemented:\n\n"
implemented_something = false;
for(var i=0; i<global.N_MEASURES; i++) {
	if global.state.measures_implemented[i] > 0 {
		implemented_something = true;
		var measure = global.measures[?i];
		text += string("{0}: {1} {2}{3}\n",
			measure.name, global.state.measures_implemented[i],
			measure.unit, (global.state.measures_implemented[i]>1) ? "s" : "")
	}
}
if !implemented_something {
	text += "\nNothing :(\n"	
}
text +=  "\n\nIn the weeks after the meeting:\n\n"
for(var i=0; i<array_length(global.state.round_reports); i++) {
	text += global.state.round_reports[i] + "\n"
}

scale=1
h_align = fa_left