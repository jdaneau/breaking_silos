draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_center)
var text = "";
for(var i=0; i<ds_list_size(global.chat); i++) {
	if i > 0 text += "\n"
	text += ds_list_find_value(global.chat,i)
}
draw_text(room_width/4,room_height/2,text)