var _id = ds_map_find_value(async_load, "id");
if _id == is_server_msg
{
    if ds_map_find_value(async_load, "status") {
        instance_create_layer(0,0,"Instances",objServer)
		show_debug_message("Server initialized")
    }
	else {
		instance_create_layer(0,0,"Instances",objClient)
		show_debug_message("Client initialized")
	}	
}