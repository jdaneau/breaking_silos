draw_set_font(fChat)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

var sep = 12;
var max_w = sprite_get_width(sprite_index);

var text_w = string_width_ext(text,sep,max_w);
var text_h = string_height_ext(text,sep,max_w);
var w = text_w + 32;
var h = text_h + 128;
var text_x = round(x + (w/2));
var text_y = round(y + 16 + (text_h / 2));

draw_sprite_ext(sprite_index,0,x,y,w/sprite_get_width(sprite_index),h/sprite_get_height(sprite_index),0,c_white,0.5)
draw_set_color(c_black)
draw_text(text_x,text_y,text)
draw_set_color(c_white)

draw_color_rectangle(x+(w/2)-32, y+text_h+64, x+(w/2)+32, y+text_h+96,c_black,true)
draw_set_color(c_black)
draw_text(x+(w/2),y+text_h+64+16,"OK")

