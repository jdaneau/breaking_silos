var box_size = sprite_height;

draw_set_font(font)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

//left arrow
draw_color_rectangle(x,y,x+box_size,y+box_size,c_white,false);
draw_color_rectangle(x,y,x+box_size,y+box_size,c_black,true);
draw_text_color(x+(box_size/2),y+(box_size/2),"<",c_black,c_black,c_black,c_black,1)

//right arrow
draw_color_rectangle(x+sprite_width-box_size,y,x+sprite_width,y+box_size,c_white,false);
draw_color_rectangle(x+sprite_width-box_size,y,x+sprite_width,y+box_size,c_black,true);
draw_text_color(x+sprite_width-(box_size/2),y+(box_size/2),">",c_black,c_black,c_black,c_black,1)

//selected option
draw_text_color(x+(sprite_width/2),y+(sprite_height/2),selected,c_black,c_black,c_black,c_black,1)