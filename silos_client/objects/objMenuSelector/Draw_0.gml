var box_size = sprite_height;
var arrow_radius = 12;
var box_width = sprite_width - (arrow_radius * 4) - 16;

draw_set_font(fMyriadBold12)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

//left arrow
draw_circle_color(x+arrow_radius,y+(box_size/2),arrow_radius,global.colors.light_blue,global.colors.light_blue, false)
draw_text_color(x+arrow_radius,y+(box_size/2),"<",c_white,c_white,c_white,c_white,1)

//right arrow
draw_circle_color(x+sprite_width-arrow_radius,y+(box_size/2),arrow_radius,global.colors.light_blue,global.colors.light_blue, false) 
draw_text_color(x+sprite_width-arrow_radius,y+(box_size/2),">",c_white,c_white,c_white,c_white,1)

//selected option
draw_set_font(font)
draw_roundrect_color(x+(arrow_radius*2)+8,y,x+sprite_width-(arrow_radius*2)-8,y+box_size,global.colors.dark_blue_75, global.colors.dark_blue_75, false)
draw_text_color(x+(sprite_width/2),y+(sprite_height/2),selected,c_white,c_white,c_white,c_white,1)

if mouse_check_pressed(mb_left) {
	//left arrow
	if coords_in(mouse_x,mouse_y,x,y+(box_size/2)-arrow_radius,x+(arrow_radius*2),y+(box_size/2)+arrow_radius) {
		index--
		if index < 0 {
			index = array_length(options) - 1	
		}
	}
	
	//right arrow
	if coords_in(mouse_x,mouse_y,x+sprite_width-(arrow_radius*2),y+(box_size/2)-arrow_radius,x+sprite_width,y+(box_size/2)+arrow_radius) {
		index++
		if index >= array_length(options) {
			index = 0	
		}
	}
}

