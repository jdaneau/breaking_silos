ping = 0
port = 20002
server_ip = "127.0.0.1"
socket = network_create_socket(network_socket_ws)


network_connect_async(socket,server_ip,port)
client_buffer = buffer_create(1024,buffer_fixed,1)

global.chat = ds_list_create()

name_msg = get_string_async("Name?","")