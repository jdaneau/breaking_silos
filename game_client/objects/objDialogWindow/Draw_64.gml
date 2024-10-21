draw_set_alpha(0.75)
draw_color_rectangle(0,0,room_width,room_height,c_black,false)
draw_set_alpha(1)

draw_self()

draw_set_font(fChat)
draw_set_halign(fa_center)
draw_set_valign(fa_top)

var sep = font_get_size(fChat)*1.5;
var w = sprite_width-32;
var prompt_height = string_height_ext(prompt,sep,w);
var allowed_prompt_height = sprite_height * 0.6;
var prompt_y = y+16 + (allowed_prompt_height / 2) - (prompt_height / 2);
draw_text_ext_color(x+(sprite_width/2),prompt_y,prompt,sep,w,c_black,c_black,c_black,c_black,1)

if question {
	draw_set_font(fInput)
	var textbox_y = y+sprite_height-96;
	var textbox_h = 32;
	var draw_keyboard_string = keyboard_string;
	while string_width(draw_keyboard_string) > (sprite_width-32) {
		draw_keyboard_string = string_copy(draw_keyboard_string,2,string_length(keyboard_string)-1)	
	}
	draw_gui_border(x+16,textbox_y,x+sprite_width-16,textbox_y+textbox_h)
	var textX = x+16+4;
	var textY = textbox_y+8
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	draw_text_color(textX,textY,draw_keyboard_string,c_black,c_black,c_black,c_black,1)
	var str_end = textX + string_width(draw_keyboard_string) + 4;
	var line_height = string_height("h");
	if line_flash and str_end < (x+sprite_width-16) {
		draw_line_color(str_end,textY,str_end,textY+line_height,c_black,c_black)
	}
	
	var buttonX = x+(sprite_width/2)-64;
	var buttonY = y+sprite_height-48;
	var hover = coords_in(mouse_x,mouse_y,buttonX,buttonY,buttonX+128,buttonY+32);
	if hover {
		draw_color_rectangle(buttonX,buttonY,buttonX+128,buttonY+32,c_ltgray,false)
		if mouse_check_pressed(mb_left) {
			confirm(keyboard_string)
			instance_destroy()
		}
	}
	if can_exit and keyboard_check_pressed(vk_enter) {
		confirm(keyboard_string)
		instance_destroy()	
	}
	draw_gui_border(buttonX,buttonY,buttonX+128,buttonY+32)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fChat)
	draw_text_color(x+(sprite_width/2),buttonY+16,"Confirm",c_black,c_black,c_black,c_black,1)
} else {
	var width = sprite_width-32;
	var sep_width = 16;
	var button_width = (width - sep_width*(array_length(options)-1)) / array_length(options);
	for(var i=0; i<array_length(options); i++) {
		var drawX = x+16 + (i * button_width) + (i * sep_width);
		var drawY = y+sprite_height-64;
		var hover = coords_in(mouse_x,mouse_y,drawX,drawY,drawX+button_width,drawY+48);
		if hover {
			draw_color_rectangle(drawX,drawY,drawX+button_width,drawY+48,c_ltgray,false)
			if mouse_check_pressed(mb_left) {
				confirm(options[i])
				instance_destroy()
			}
		}
		draw_gui_border(drawX,drawY,drawX+button_width,drawY+48)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_text_color(drawX+(button_width/2),drawY+24,options[i],c_black,c_black,c_black,c_black,1)
	}
}