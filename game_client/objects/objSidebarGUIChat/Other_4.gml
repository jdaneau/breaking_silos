draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(fChat)

var _height = 0;
for(var i=0; i<array_length(chat); i++) {
	_height += string_height_ext(chat[i],sep,sprite_width-32) + 16	
}
if _height > sprite_height {
	chat_scroll = 	_height - sprite_height
}