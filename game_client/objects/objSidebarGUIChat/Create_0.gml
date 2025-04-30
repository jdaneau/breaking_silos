chat = []
chat_scroll = 0
sep = 24
home_room =room
font_author = fMyriadBold12
font_chat = fMyriad12
chat_surface_w = sprite_width - 48;
chat_surface_h = sprite_height * 10;
current_chat_height = 0;
send_area_height = sprite_get_height(sprSendMessage) * 1.25;
chat_window_height = sprite_height - send_area_height - 16;

function chat_add(author,msg) {
	if object_index == objSidebarGUIChat
		array_push(chat,{author:author,msg:msg})
	else 
		array_push(objSidebarGUIChat.chat,{author:author,msg:msg})
}

chat_surface = surface_create(chat_surface_w,chat_surface_h)

mouse_on = false

chat_max_length = 500
chat_typing = false
chat_message = ""
backspace_timer = floor(game_get_speed(gamespeed_fps) * 0.5);
backspace_t = 0;
line = false;
line_t = 0;