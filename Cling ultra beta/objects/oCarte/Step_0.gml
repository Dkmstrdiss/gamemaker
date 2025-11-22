// Smoothly move card towards target_x/target_y and apply target_depth when reached
if (!variable_instance_exists(id, "target_x")) {
    // no targets defined
    exit;
}

var dx = target_x - x;
var dy = target_y - y;
var dist = point_distance(x, y, target_x, target_y);

if (dist > move_tolerance) {
    x += dx * move_speed;
    y += dy * move_speed;
} else {
    x = target_x;
    y = target_y;
}

// Apply depth target once position is settled (or immediately if different)
if (is_undefined(target_depth)) {
    // nothing to do
} else {
    if (depth != target_depth) {
        depth = target_depth;
    }
}
