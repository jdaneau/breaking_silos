var all_players = ds_map_size(sockets);

draw_set_color(c_white)
draw_set_halign(fa_center)
draw_text(room_width/2,room_height/3,"Connected Players: " + string(all_players))