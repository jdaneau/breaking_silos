//check if the server is still alive

if connected { timeout=false; exit } //dont ping server if in game otherwise people will randomly disconnect which is annoying

send(MESSAGE.PING)
timeout = true

alarm[0] = timeout_interval
alarm[1] = timeout_time