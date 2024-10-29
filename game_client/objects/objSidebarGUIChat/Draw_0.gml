if room != home_room { exit; }
if !surface_exists(chat_surface) chat_surface = surface_create(sprite_width,sprite_height*2)

draw_set_color(c_ltgray)
draw_rectangle(x,y,x+sprite_width,y+sprite_height,false)
draw_set_color(c_white)

draw_set_halign(fa_left)
draw_set_valign(fa_top)
surface_set_target(chat_surface)
draw_clear_alpha(c_white,0)
draw_set_color(c_black)
draw_set_font(fChat)
var _y = sprite_height*2;
for(var _i=array_length(chat)-1; _i>=0; _i--) {
	_y -= string_height_ext(chat[_i],sep,sprite_width-16) + 16
	draw_text(8,_y,"-")
	draw_text_ext(16,_y,chat[_i],sep,sprite_width-16)
	if _y <= 0 { break }
}
surface_reset_target()
draw_set_color(c_white)

draw_surface_part(chat_surface,0,sprite_height-chat_scroll,sprite_width,sprite_height,x,y)

if chat_scroll > 0 {
	draw_sprite_ext(sprSmallDownArrow,0,x+64,y+sprite_height-16,1,1,0,c_white,0.8)
	draw_sprite_ext(sprSmallDownArrow,0,x+(sprite_width/2),y+sprite_height-16,1,1,0,c_white,0.8)
	draw_sprite_ext(sprSmallDownArrow,0,x+sprite_width-64,y+sprite_height-16,1,1,0,c_white,0.8)
}

draw_gui_border(x,y,x+sprite_width,y+sprite_height)