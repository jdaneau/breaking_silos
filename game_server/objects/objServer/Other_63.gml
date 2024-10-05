var _id, _stat, _msg;
_id = ds_map_find_value(async_load, "id");
if _id == announce_msg
{
    if ds_map_find_value(async_load, "status")
    {
        if ds_map_find_value(async_load, "result") != ""
        {
            _msg = ds_map_find_value(async_load, "result");
			show_debug_message(_msg)
			send_to_all(1,buffer_string,_msg)
        }
    }
}

