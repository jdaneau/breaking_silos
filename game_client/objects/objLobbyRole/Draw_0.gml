var icon_size = sprite_height * (3/4);
var icon_scale = icon_size / sprite_get_width(icon);
draw_sprite_ext(icon,0,x,y,icon_scale,icon_scale,0,c_white,1)

draw_set_font(fTooltip)
draw_set_color(c_black)
var player_caption = "Player: " + objOnline.get_role_player(role);
var max_caption_size = icon_size + 64;
while string_width(player_caption) > max_caption_size {
	player_caption = string_copy(player_caption,1,string_length(player_caption)-1)
}
if !string_ends_with(player_caption,objOnline.get_role_player(role)) {
	player_caption = string_copy(player_caption,1,string_length(player_caption)-3) + "..."	
}

draw_set_halign(fa_left)
draw_set_valign(fa_bottom)
draw_text(x,y+sprite_height,player_caption)

draw_set_font(fHeaderBold)
draw_set_valign(fa_middle)
if string_width(global.roles[? role].name) > (sprite_width - icon_size - 8) {
	draw_set_font(fSidebarBold)	
}
draw_text(x+icon_size+8, y+sprite_height*(3/8) - 16, global.roles[? role].name)

draw_set_font(fChat)
draw_text(x+icon_size+8, y+sprite_height*(3/8) + 16, global.roles[? role].description)

draw_set_color(c_white)