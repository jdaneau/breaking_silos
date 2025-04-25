var subimg = 0;
var caption_color = global.colors.light_blue;

if show {
	caption_color = c_ltgray
	subimg = 2
} else if hover {
	subimg = 1
	caption_color = global.colors.light_blue_50 
}

draw_sprite(sprite,subimg,x,y)
draw_set_color(caption_color)
draw_set_font(font)
draw_set_halign(fa_center)
draw_set_valign(fa_top)
draw_text(x+(sprite_width/2),y+75+8,text)
draw_set_color(c_white)
