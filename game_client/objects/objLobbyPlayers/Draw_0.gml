draw_gui_border(x,y,x+sprite_width,y+sprite_height,global.colors.light_blue_75,false)
draw_gui_border(x,y,x+sprite_width,y+sprite_height)

draw_set_font(fMyriad14)
draw_set_halign(fa_left)
draw_set_valign(fa_bottom)
draw_set_color(global.colors.yellow)

draw_text(x+24,y+64,"CONNECTED PLAYERS : ")
var number_x = string_width("CONNECTED PLAYERS : ");
draw_set_color(c_white)
draw_set_font(fMyriadBold16)
draw_text(x+24+number_x,y+64,string(ds_map_size(objOnline.players)))

draw_set_font(fMyriad12)
draw_set_valign(fa_top)
var text = "";
var names = ds_map_keys_to_array(objOnline.players);
for(var i=0; i<array_length(names); i++) {
	var line = "- " + names[i];

	while string_width(line) > sprite_width {
		line = string_copy(line,1,string_length(line)-1)
	}
	if !string_ends_with(line,names[i]) {
		line = string_copy(line,1,string_length(line)-3) + "..."	
	}
	text += "\n" + line
}
draw_text(x+24,y+64+8,text)
