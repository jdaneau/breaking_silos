text="CREDITS"
on_click=function(on) {
	instance_create_depth(room_width/2,room_height/2,-50,objCredits)
	with instance_create_depth(1300,80,-60,objGUIButton) {
		image_xscale = 1.25
		image_yscale = 0.3
		text = "CLOSE"
		on_click = function(on) {
			with objCredits instance_destroy()
			instance_destroy()
		}
	}
}
inverted = true