/// Machine d'état du tour (phase -> phase)
/// Chaque frame : on avance le timer, anime la roue et gère les raccourcis.
var dt = 1 / room_speed;                         // Pas de temps fixe (en secondes)
phase_timer += dt;                               // Temps passé dans la phase courante
var rotation_diff = angle_difference(phase_wheel_target, phase_wheel_rotation);
phase_wheel_rotation += rotation_diff * clamp(dt * 6, 0, 1); // Animation lissée de la roue

// Fenêtre de mulligan avant le début de la partie : bloque le reste de la boucle
// jusqu'à ce que le joueur valide (Entrée/Espace) ou force un mulligan (M/L).
if (mulligan_phase_active) {
    if (keyboard_check_pressed(ord("M"))) {
        perform_mulligan(player_a);
    }
    if (keyboard_check_pressed(ord("L"))) {
        perform_mulligan(player_b);
    }
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        close_mulligan_window();
    }
    exit;
}

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
