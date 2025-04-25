
if coords_in(mouse_x,mouse_y,x-32,y,bbox_right+32,bbox_bottom+96) {
	hover = true	
} else hover = false


if selected == -1 {
	text = "Select Map Layer"
	sprite = sprDropdownButton
}

else {
	var button = buttons[selected];
	text = button.text;
	sprite = button.sprite;
}

if global.mouse_depth < depth hover = false

dropdown_height = button_height * ceil((array_length(buttons)+1) / 2)