var n_damaged = get_n_damaged_cells();
text = "Cells with damaged buildings: " + string(n_damaged)
if n_damaged > 0 {
	color = c_red	
} else color = c_lime