//draw_set_color(c_black)
draw_set_color(c_white)
draw_rectangle(x,y,x+sprite_width,y+sprite_height,false)
draw_gui_line(x+sprite_width,y,x+sprite_width,y+sprite_height)
//draw_set_color(c_white)


//draw screen border
draw_gui_border(2,2,room_width-3,room_height-3)