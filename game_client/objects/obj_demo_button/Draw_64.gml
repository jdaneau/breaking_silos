/// @description DEMO: Draw button

// Get current drawing properties
var fnt = draw_get_font();
var halign = draw_get_halign();
var valign = draw_get_valign();

// Set drawing properties
draw_set_font(fnt_debug_200);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw button and text label
draw_self();
draw_text_transformed(x, y, label, image_xscale*0.5, image_yscale*0.5, image_angle);

// Reset drawing properties
draw_set_font(fnt);
draw_set_halign(halign);
draw_set_valign(valign);