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

draw_set_alpha(0.5)
draw_color_rectangle(x,y,x+sprite_width,y+sprite_height,c_white,false)
draw_set_alpha(1)
draw_gui_border(x,y,x+sprite_width,y+sprite_height)
var textX = x+4;
var textY = y+8
draw_set_halign(fa_left)
draw_set_valign(fa_top)
	
draw_text_color(textX,textY,text,c_black,c_black,c_black,c_black,1)
var str_end = textX + string_width(text) + 4;
var line_height = string_height("h");
if active and line_flash and str_end < (x+sprite_width) {
	draw_line_color(str_end,textY,str_end,textY+line_height,c_black,c_black)
}