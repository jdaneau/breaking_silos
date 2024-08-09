draw_self()

if mouse_on {
	draw_set_alpha(0.3)
	draw_rectangle(x,y,x+64,y+64,false)
	draw_set_alpha(1)
}