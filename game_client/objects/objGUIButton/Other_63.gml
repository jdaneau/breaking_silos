///handle dialog popups
var i_d = ds_map_find_value(async_load, "id");
if i_d == dialog {
	if dialog_mode == "question" {
		if ds_map_find_value(async_load, "status")   {
		    switch(dialog_status) {
				case "end_discussion":
					end_discussion() //end the discussion
				break;
				case "end_round":
					//end_round()
				break;
			}
		}
	}
	/*
	else if dialog_mode == "prompt" {
		if ds_map_find_value(async_load, "status")   {
		    if ds_map_find_value(async_load, "result") != ""
	        {
				switch(dialog_status) {
				
				}
	        }
		}
	}
	*/
}