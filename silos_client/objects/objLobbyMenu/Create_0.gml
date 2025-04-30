lobbies = []

w = sprite_width
h = sprite_height
surf_h = round(sprite_height / 3 * 10)
surf = surface_create(w,surf_h)

scroll = 0
max_scroll = 0

row_w = w-8
row_h = round((h-64) / 3)
row_sep = 16

scroll_click = false
scroll_mouse_y = 0

mouse_surf_x = 0
mouse_surf_y = 0

button_click = []

home_room = room