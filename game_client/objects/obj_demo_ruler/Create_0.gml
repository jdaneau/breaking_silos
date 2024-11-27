/// @description DEMO: Initialize ruler object

// Center object sprite
sprite_set_offset(sprite_index, (sprite_width*0.5), (sprite_height*0.5));

// Initialize click-n-drag
move = false;

// Ruler objects operate in pairs. Create array of ruler objects for pairing
ruler = instance_number(object_index) - 1;
global.rulers[ruler] = id;
