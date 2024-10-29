font = fChat
scale = 1
h_align = fa_left
v_align = fa_top

manual_update = function() {
	text = string("Connected players: {0}",ds_map_size(objOnline.players))
	var names = ds_map_keys_to_array(objOnline.players);
	for(var i=0; i<array_length(names); i++) {
		var line = "- " + names[i];
		draw_set_font(font)
		while string_width(line) > sprite_width {
			line = string_copy(line,1,string_length(line)-1)
		}
		if !string_ends_with(line,names[i]) {
			line = string_copy(line,1,string_length(line)-3) + "..."	
		}
		text += "\n" + line
	}
}

manual_update()
