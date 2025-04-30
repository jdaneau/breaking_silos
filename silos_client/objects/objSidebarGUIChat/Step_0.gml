if room != home_room {
	surface_free(chat_surface)
	instance_destroy()
	exit
}

if coords_in(mouse_x,mouse_y,x,y,x+sprite_width,y+sprite_height) {
	mouse_on = true	
} else mouse_on = false

var current_max_scroll = clamp(current_chat_height - chat_window_height,0,chat_surface_h-chat_window_height);

var scroll_amt = sep;
if current_chat_height > (chat_window_height * 2) {
	scroll_amt = sep*2	
}

if global.mouse_depth >= depth and mouse_wheel_up() and mouse_on {
	//show_debug_message(string("chat_scroll = {0}, current_max_scroll = {1}, current_chat_height = {2}, chat_window_height = {3}",chat_scroll,current_max_scroll,current_chat_height,chat_window_height))
	chat_scroll = clamp(chat_scroll + scroll_amt, 0, current_max_scroll) 
}
if global.mouse_depth >= depth and mouse_wheel_down() and mouse_on {
	chat_scroll = clamp(chat_scroll - scroll_amt, 0, current_max_scroll) 
}

if chat_typing {
	if keyboard_string != "" {
		if string_length(chat_message + keyboard_string) < chat_max_length {
			chat_message += keyboard_string 	
		} else open_dialog_info("You reached the maximum chat message length!")
		keyboard_string = ""
	}
	if keyboard_check_pressed(vk_backspace) {
		if string_length(chat_message) > 1 {
			chat_message = string_copy(chat_message,1,string_length(chat_message)-1)
		} else chat_message = ""	
	}
	else if keyboard_check(vk_backspace) {
		backspace_t += 1
		if backspace_t >= backspace_timer {
			backspace_t = 0
			backspace_timer = 5
			if string_length(chat_message) > 1 {
				chat_message = string_copy(chat_message,1,string_length(chat_message)-1)
			} else chat_message = ""
		}
	} else { backspace_t = 0; backspace_timer = floor(game_get_speed(gamespeed_fps)*0.5) }
	
	if chat_message != "" and  keyboard_check_pressed(vk_enter) {
		send_string(MESSAGE.CHAT,chat_message)
		chat_message=""
	}
}