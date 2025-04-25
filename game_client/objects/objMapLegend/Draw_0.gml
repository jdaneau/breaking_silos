draw_roundrect_ext(tab_x,tab_y-h,tab_x+tab_w,tab_y-h+tab_h+8,8,8,false)

draw_set_color(global.colors.light_blue)
draw_set_font(fMyriadBold12)

draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_text(tab_x+(tab_w/2),tab_y-h+(tab_h/2),"v")

draw_set_halign(fa_left)
draw_set_font(fMyriadBold14)
draw_text(label_x,tab_y-h+(tab_h/2),"Map Legend")

draw_sprite_part(sprite_index,0,0,0,sprite_width,h,x,y-h)