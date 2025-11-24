/// Initialise une carte préchargée pour le combat

card_info  = undefined;
card_id    = -1;
owner_id   = undefined;

image_index = 0;
image_speed = 0;
visible     = true;
// Movement targets used by oHand / odeck to position cards
target_x = x;
target_y = y;
target_depth = depth;
move_speed = 0.25; // interpolation factor (0..1)
move_tolerance = 1.0; // distance to snap
