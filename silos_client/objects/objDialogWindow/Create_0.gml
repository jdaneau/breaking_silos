old_depth = global.mouse_depth
global.mouse_depth = depth

prompt = "I'm a dialog box!"

question = false
line_flash = false
t=0
keyboard_string = ""

options = ["Yes","No"]

confirm = function(answer) {
	show_debug_message("Dialog box closed with answer: " + answer)	
}

x = (room_width/2) - (sprite_width/2)
y = (room_height/2) - (sprite_height/2)

can_exit = false
alarm[0] = 1