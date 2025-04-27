draw_self()

surface_set_target(surf)

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_black)

var _y = 16;
for(var i=0; i<array_length(text); i++) {
	if i == 0 draw_set_font(fMyriadBold16) else draw_set_font(fMyriad14)
	draw_text_ext(16,_y,text[i],sep,max_w-32)
	_y += string_height_ext(text[i],sep,max_w-32) + sep
}

draw_set_color(c_white)
surface_reset_target()