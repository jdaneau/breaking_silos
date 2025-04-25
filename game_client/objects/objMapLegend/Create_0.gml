image_speed=0
depth = -1

h=0
mouse_on = false

index = 0;
if objOnline.lobby_settings.climate_type == "Tropical" { index = 1 }
if objOnline.lobby_settings.climate_type == "Boreal" { index = 2 }

tab_x = x + 16;
tab_y = y - 48;
tab_w = 32;
tab_h = 32;

label_x = tab_x + tab_w + 8;