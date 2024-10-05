var _id = ds_map_find_value(async_load, "id");
if _id == name_msg
{
    if ds_map_find_value(async_load, "status")
    {
        if ds_map_find_value(async_load, "result") != ""
        {
            var _name = ds_map_find_value(async_load, "result");
			send_string(client_buffer, MESSAGE.CONNECT, _name)
        }
    }
}

