/// init surface

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(fDescription)
max_w = room_width/3.5
max_h = string_height_ext(text,16,max_w-16) + 100
surf = surface_create(max_w,max_h)