/// Machine d'état du tour (phase -> phase)
var delta_time = 1 / room_speed;
phase_timer += delta_time;
var rotation_diff = angle_difference(phase_wheel_target, phase_wheel_rotation);
phase_wheel_rotation += rotation_diff * clamp(delta_time * 6, 0, 1);

// Raccourcis debug : avancer ou mulligan manuel
if (keyboard_check_pressed(vk_space)) {
    advance_phase();
}
if (keyboard_check_pressed(ord("M"))) {
    perform_mulligan(get_player(turn_player_id));
}
if (keyboard_check_pressed(ord("A"))) {
    auto_advance_phases = !auto_advance_phases;
}

if (auto_advance_phases) {
    var target = phase_duration(current_phase);
    if (phase_timer >= target) {
        advance_phase();
    }
}
