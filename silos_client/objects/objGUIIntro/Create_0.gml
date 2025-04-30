old_depth = global.mouse_depth
global.mouse_depth = depth // should be -200

mid_x = 800; //center of the screen
mid_y = 450;

popup_size = sprite_get_width(sprIntroPopup) - 32; // remove 16px shadow buffer from sprite width
popup_x = mid_x - (popup_size / 2);
popup_y = mid_y - (popup_size / 2);
popup_bottom = popup_y + popup_size;

button_width = 128;
button_height = 48;
button_x = mid_x - (button_width/2);
button_y = popup_bottom - 96;

my_button = instance_create_depth(button_x,button_y,depth-1,objGUIButton);
my_button.text = "START"
my_button.on_click = function(on) {
	with objGUIIntro { instance_destroy() }	
}
resize_object(my_button, button_width, button_height)

