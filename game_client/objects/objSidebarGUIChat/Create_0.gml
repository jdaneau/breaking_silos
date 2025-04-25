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
    array_push(objSidebarGUIChat.chat,{author:author,msg:msg})
}

if room == rInGame {
	chat_add("Server",string("We are currently facing a {0} of {1} intensity. You must work together to implement the best DRR measures! Read your role-specific description by hovering over the question mark next to your avatar. Good luck!",global.state.disaster,global.state.disaster_intensity))
}
else if room == rGameResults {
	chat_add("Server", "The last round has finished! Now is the time to reflect on the decisions made during the game and determine what went right and what went wrong.")
	chat_add("Server", "Here are some possible discussion points:")
	chat_add("Server", "What role-specific challenges did you face and how did you overcome them?")
	chat_add("Server", "How did you deal with the budget limitation? Was there enough emphasis placed on long-term solutions?")
	chat_add("Server", "Would your strategy have worked better/worse under different circumstances?")
	chat_add("Server", "What other multi-hazard interactions can you image that aren't represented in this game, and how could they change the DRR strategy?")
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