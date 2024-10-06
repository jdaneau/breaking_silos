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