draw_gui_button(x,y,x+sprite_width,y+sprite_height,global.colors.light_blue,c_white,"")

draw_set_font(fMyriadBold14)
draw_set_halign(fa_left)
draw_set_valign(fa_middle)
draw_set_color(c_black)

var draw_x = x+24;
var draw_y = y+(sprite_height/2);

var round_str = string("Round {0}/{1}",global.state.current_round,objOnline.lobby_settings.n_rounds);
draw_text(draw_x,draw_y,round_str)
draw_x += string_width(round_str) + 8

draw_set_color(c_white)
draw_sprite(sprSeparatorDots,0,draw_x,draw_y)
draw_x += sprite_get_width(sprSeparatorDots) + 8

draw_sprite(sprCoin,0,draw_x,draw_y)
draw_x += sprite_get_width(sprCoin) + 8

draw_set_color(c_black)

draw_text(draw_x,draw_y,string(money))
draw_x += string_width(string(money)) + 8

draw_set_color(c_white)
draw_sprite(sprSeparatorDots,0,draw_x,draw_y)
draw_x += sprite_get_width(sprSeparatorDots) + 8

draw_sprite(sprClock,0,draw_x,draw_y)
draw_x += sprite_get_width(sprClock) + 8

var _minutes = global.state.seconds_remaining div 60;
var _seconds = global.state.seconds_remaining mod 60;
if _minutes < 10 { _minutes = "0"+string(_minutes) }
if _seconds < 10 { _seconds = "0"+string(_seconds) }
var time = string("{0}:{1}",_minutes,_seconds);

draw_set_color(c_black)
draw_text(draw_x,draw_y,time)
draw_set_color(c_white)