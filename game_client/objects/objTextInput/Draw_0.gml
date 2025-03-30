draw_set_font(fInput)

if active {
	if keyboard_string != "" {
		if string_width(text + keyboard_string) < sprite_width {
			text += keyboard_string 	
		}
		keyboard_string = ""
	}
	if keyboard_check_pressed(vk_backspace) {
		if string_length(text) > 1 {
			text = string_copy(text,1,string_length(text)-1)
		} else text = ""
	}
}

draw_gui_border(x,y,x+sprite_width,y+sprite_height,global.colors.dark_blue_75,false)
var textX = x+4;
var textY = y+8
draw_set_halign(fa_left)
draw_set_valign(fa_top)
	
draw_text_color(textX,textY,text,text_color,text_color,text_color,text_color,1)
var str_end = textX + string_width(text) + 4;
var line_height = string_height("h");
if active and line_flash and str_end < (x+sprite_width) {
	draw_line_width_color(str_end,textY,str_end,textY+line_height,2,text_color,text_color)
}