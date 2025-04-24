if global.state.current_phase == "discussion" {
	draw_set_font(fSidebar)
	draw_set_color(c_black)

	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)

	var _minutes = global.state.seconds_remaining div 60;
	var _seconds = global.state.seconds_remaining mod 60;
	if _minutes < 10 { _minutes = "0"+string(_minutes) }
	if _seconds < 10 { _seconds = "0"+string(_seconds) }
	draw_text(x,y+(sprite_height/2),string("Time Remaining: {0}:{1}",_minutes,_seconds))

	draw_set_color(c_white)
}