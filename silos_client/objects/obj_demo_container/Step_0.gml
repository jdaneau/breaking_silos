/// @description DEMO: Update container object

// Update container position
x = view_xcenter;
y = view_ycenter + 64;

// Link buttons to container position, rotation, and scale
instance_link(self, obj_demo_button, true, true, true);