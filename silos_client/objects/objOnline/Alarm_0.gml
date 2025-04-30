//check if the server is still alive
send(MESSAGE.PING)
timeout = true

alarm[0] = timeout_interval
alarm[1] = timeout_time