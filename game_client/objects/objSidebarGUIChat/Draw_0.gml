if room != home_room { exit; }
if !surface_exists(chat_surface) chat_surface = surface_create(chat_surface_w,chat_surface_h)

//draw chat surface
draw_set_halign(fa_left)
draw_set_valign(fa_top)
surface_set_target(chat_surface)
draw_clear_alpha(c_white,0)
draw_set_color(c_black)
var _y = chat_surface_h;
for(var _i=array_length(chat)-1; _i>=0; _i--) {
	if _y <= 0 { break }
	var msg = chat[_i].msg;
	var author = chat[_i].author;
	draw_set_font(font_chat)
	if _i < array_length(chat)-1 {
		_y -= (sep/2)
		if _y <= 0 { break }
		draw_set_alpha(0.6)
		draw_line(0,_y,chat_surface_w,_y)
		draw_set_alpha(1)
		_y -= (sep/2)
		if _y <= 0 { break }
	}
	_y -= string_height_ext(msg,sep,chat_surface_w) + 8
	if _y <= 0 { break }
	draw_text_ext(0,_y,msg,sep,chat_surface_w)
	draw_set_font(font_author)
	_y -= string_height(author) + 2;
	if _y <= 0 { break }
	draw_text(0,_y,author)
}
surface_reset_target()
draw_set_color(c_white)

current_chat_height = clamp(chat_surface_h - _y,0,chat_surface_h);

//draw chat window
var chat_window_x = x + 16;
var chat_window_y = y + 16;

draw_set_color(c_ltgray)
draw_roundrect_ext(x,y,x+sprite_width,y+sprite_height,12,12,false)
draw_surface_part(chat_surface,0,chat_surface_h-chat_window_height-chat_scroll,chat_surface_w,chat_window_height,chat_window_x,chat_window_y)

draw_set_color(c_white)
var scrollbar_h = chat_window_height;
var scrollbar_y = chat_window_y;
if current_chat_height > chat_window_height {
	scrollbar_y += chat_window_height - scrollbar_h
	scrollbar_h = (chat_window_height / current_chat_height) * chat_window_height
	scrollbar_y -= (chat_scroll / (current_chat_height - chat_window_height)) * (chat_window_height - scrollbar_h)
}
var scrollbar_w = 12;
var scrollbar_x = x + 16 + chat_surface_w + ((32 - scrollbar_w) / 2);
draw_roundrect_ext(scrollbar_x,chat_window_y,scrollbar_x+scrollbar_w,chat_window_y+chat_window_height,12,12,false)

draw_set_color(c_gray)
draw_roundrect_ext(scrollbar_x,scrollbar_y,scrollbar_x+scrollbar_w,scrollbar_y+scrollbar_h,12,12,false)
draw_set_color(c_white)

//draw (and handle) sending message area
var send_area_y = chat_window_y + chat_window_height;
draw_rectangle(x,send_area_y,x+sprite_width,send_area_y+(send_area_height/2),false)
draw_roundrect_ext(x,send_area_y,x+sprite_width,y+sprite_height,12,12,false)

//draw outline
draw_set_color(c_black)
draw_roundrect_ext(x,y,x+sprite_width,y+sprite_height,12,12,true)
draw_set_color(c_white)