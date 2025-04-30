t++

if scale_phase == 0 {
	scale += 0.02
	if scale >= 1.4 { scale_phase = 1; t=0 }
}
else if scale_phase == 1 {
	if t == 30 { scale_phase = 2; t=0 }	
}
else if scale_phase == 2 {
	scale -= 0.02
	if scale == 1 { scale_phase = 3; t=0 }
}
else if scale_phase == 3 {
	if t == 60 { scale_phase = 4; t=0 }	
}
else if scale_phase == 4 {
	alpha -= 0.05
	if alpha <= 0 instance_destroy()
}