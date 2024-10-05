var _id, _stat, _name;
_id = ds_map_find_value(async_load, "id");
if _id == name_msg
{
    if ds_map_find_value(async_load, "status")
    {
        if ds_map_find_value(async_load, "result") != ""
        {
            _name = ds_map_find_value(async_load, "result");
			show_debug_message(_name)
			buffer_seek(client_buffer,buffer_seek_start,0)
			buffer_write(client_buffer,buffer_u8,4)
			buffer_write(client_buffer,buffer_string,_name)
			network_send_packet(socket,client_buffer,buffer_tell(client_buffer))
        }
    }
}

