if selected == -1 {
	text = "Select Map Layer"	
}

else {
	var button = buttons[selected];
	text = button.text;
}

if global.mouse_depth < depth hover = false

dropdown_height = (sprite_height * (2/3)) * (array_length(buttons)+1)