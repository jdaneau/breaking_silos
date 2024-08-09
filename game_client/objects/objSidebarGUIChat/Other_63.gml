var i_d = ds_map_find_value(async_load, "id");
if i_d == chat_message
{
    if ds_map_find_value(async_load, "status")
    {
        if ds_map_find_value(async_load, "result") != ""
        {
			chat_add(ds_map_find_value(async_load, "result"))
        }
    }
}