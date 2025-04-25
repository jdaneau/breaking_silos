draw_set_font(font)
draw_set_halign(h_align)
draw_set_valign(v_align)
draw_set_alpha(alpha)

var _x = x;
var _y = y;
if h_align == fa_center { _x = x + sprite_width/2 }
if v_align == fa_middle { _y = y + sprite_height/2 }
if h_align == fa_right { _x = x + sprite_width }
if v_align == fa_bottom { _y = y + sprite_height }

if outline {
	draw_set_color(outline_color)
	draw_text_ext_transformed(_x-1,_y,text,20*scale,sprite_width,scale,scale,image_angle)
	draw_text_ext_transformed(_x+1,_y,text,20*scale,sprite_width,scale,scale,image_angle)
	draw_text_ext_transformed(_x,_y-1,text,20*scale,sprite_width,scale,scale,image_angle)
	draw_text_ext_transformed(_x,_y+1,text,20*scale,sprite_width,scale,scale,image_angle)
}
draw_set_color(color)
draw_text_ext_transformed(_x,_y,text,20*scale,sprite_width,scale,scale,image_angle)

draw_set_color(c_white)
draw_set_alpha(1)