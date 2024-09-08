with objMapTile move_snap(64,64)
with objRiverH move_snap(16,16)
with objHospital move_snap(16,16)
with objAirport move_snap(16,16)

with objMapTile event_user(0)

event_user(0) // parse map into json

with objController instance_destroy()
room_goto(rInit)