/// oGameController : contrôle principal du duel
/// - Instancie les joueurs
/// - Construit/mélange les decks
/// - Donne la main de départ (+ support mulligan)
/// - Gère la machine d'état des phases
///
/// L'objectif de ce script est pédagogique : chaque bloc est commenté pour
/// montrer le rôle précis des helpers et des variables.

// --------------------------------------------------
// Paramètres généraux : réinitialise les constantes du mode de jeu.
// Mode_Init() configure notamment les enums Phase / PlayerId.
// --------------------------------------------------
Mode_Init();

starting_hand_size   = 5;
turn_player_id       = PlayerId.PlayerA;
turn_count           = 1;
auto_advance_phases  = true;
phase_sequence       = [Phase.Draw, Phase.Main, Phase.Attack, Phase.Defense, Phase.Resolution];
phase_labels         = ["Pioche", "Main", "Attaque", "Défense", "Résolution"];
phase_wheel_segments = array_length(phase_sequence);
phase_wheel_angle    = 360 / phase_wheel_segments;
phase_wheel_rotation = 0;
phase_wheel_target   = 0;
current_phase_index  = 0;
current_phase        = phase_sequence[current_phase_index];
phase_timer          = 0;
mulligan_phase_active = false;

// Roue de phases (UI) : segments et calcul de l'angle cible pour la roue.
phase_wheel_segments = [Phase.Draw, Phase.Main, Phase.Attack, Phase.Defense, Phase.Resolution];
phase_wheel_step     = 360 / array_length(phase_wheel_segments);
phase_wheel          = instance_exists(oWheele) ? instance_find(oWheele, 0) : noone;

/// Renvoie l'instance de roue (si détruite/recréée en cours de partie).
refresh_phase_wheel = function () {
    if (!instance_exists(phase_wheel) && instance_exists(oWheele)) {
        phase_wheel = instance_find(oWheele, 0);
    }
    return phase_wheel;
};

/// Oriente la roue sur la phase active.
update_phase_wheel = function () {
    refresh_phase_wheel();
    if (!instance_exists(oWheele)) return;

    var step_index = array_index_of(phase_wheel_segments, current_phase);
    if (step_index < 0) step_index = array_length(phase_wheel_segments) - 1;

    with (oWheele) {
        image_angle = step_index * other.phase_wheel_step;
    }
};

// --------------------------------------------------
// Helpers
// --------------------------------------------------
/// Retourne la struct joueur correspondant à l'id demandé.
get_player = function (_id) {
    return (_id == PlayerId.PlayerA) ? player_a : player_b;
};

/// Construit un deck à partir de la source (liste ou struct) passée par l'UI.
build_deck_from_source = function (_deck_source, _label) {
    return sDeckBuilder(_deck_source, _label);
};

/// Pioche une carte côté modèle (liste) et synchronise les visuels deck/main.
draw_card = function (_player) {
    if (!ds_exists(_player.deck, ds_type_list)) return undefined;
    if (ds_list_size(_player.deck) <= 0) return undefined;

    var top_index = ds_list_size(_player.deck) - 1;
    var card_info = _player.deck[| top_index];
    ds_list_delete(_player.deck, top_index);
    ds_list_add(_player.hand, card_info);

    var card_instance = noone;
    if (instance_exists(_player.deck_visual)) {
        card_instance = _player.deck_visual.pick_card_instance();
    }

    var hand_visual = _player.hand_visual;
    if (instance_exists(hand_visual)) {
        if (!instance_exists(card_instance)) {
            card_instance = hand_visual.create_card_instance(card_info);
        }
        if (instance_exists(card_instance)) {
            hand_visual.addcard(card_instance);
        }
    } else if (instance_exists(card_instance)) {
        instance_destroy(card_instance);
    }

    return card_info;
};

/// Pioche _count cartes successives.
draw_cards = function (_player, _count) {
    var drawn = 0;
    for (var i = 0; i < _count; ++i) {
        if (is_undefined(draw_card(_player))) break;
        drawn += 1;
    }
    return drawn;
};

/// Donne la main de départ et prépare le mulligan pour un joueur.
setup_starting_hand = function (_player) {
    if (instance_exists(_player.hand_visual)) {
        _player.hand_visual.clear_cards();
    }
    var drawn = draw_cards(_player, starting_hand_size);
    _player.starting_hand_size = drawn;
    _player.mulligan_available = true;
    _player.mulligan_used = false;
};

/// Effectue un mulligan complet : main remise dans le deck, mélange puis repioche.
perform_mulligan = function (_player) {
    if (!_player.mulligan_available || _player.mulligan_used) return 0;

    var hand_size = ds_list_size(_player.hand);
    for (var i = hand_size - 1; i >= 0; --i) {
        var card = _player.hand[| i];
        ds_list_delete(_player.hand, i);
        ds_list_add(_player.deck, card);
    }

    if (instance_exists(_player.hand_visual)) {
        _player.hand_visual.clear_cards();
    }

    ds_list_shuffle(_player.deck);
    if (instance_exists(_player.deck_visual)) {
        _player.deck_visual.rebuild_from_player_deck();
    }

    var drawn = draw_cards(_player, hand_size);
    _player.mulligan_used = true;
    _player.starting_hand_size = drawn;
    return drawn;
};

/// Active la fenêtre de mulligan initial (désactive l'avancement auto des phases).
open_mulligan_window = function () {
    mulligan_phase_active = true;
    auto_advance_phases   = false;
};

/// Ferme la fenêtre de mulligan puis démarre le premier tour.
close_mulligan_window = function () {
    player_a.mulligan_available = false;
    player_b.mulligan_available = false;
    mulligan_phase_active       = false;
    auto_advance_phases         = true;
    start_turn(turn_player_id);
};

/// Durée de chaque phase (utilisée par l'avancement automatique).
phase_duration = function (_phase) {
    switch (_phase) {
        case Phase.Draw:       return 0.35;
        case Phase.Main:       return 1.25;
        case Phase.Attack:     return 0.85;
        case Phase.Defense:    return 0.85;
        case Phase.Resolution: return 0.6;
    }
    return 0.75;
};

/// Début d'une phase : réinitialise le timer, met à jour l'UI et déclenche les effets.
enter_phase = function (_phase) {
    current_phase = _phase;
    phase_timer   = 0;
    phase_wheel_target = current_phase_index * phase_wheel_angle;

    update_phase_wheel();

    switch (_phase) {
        case Phase.Draw:
            draw_cards(get_player(turn_player_id), 1);
            break;
    }
};

/// Passe à la phase suivante (et gère le changement de joueur en fin de rotation).
advance_phase = function () {
    current_phase_index += 1;

    if (current_phase_index >= array_length(phase_sequence)) {
        current_phase_index = 0;
        turn_count += 1;
        turn_player_id = (turn_player_id == PlayerId.PlayerA) ? PlayerId.PlayerB : PlayerId.PlayerA;
    }

    enter_phase(phase_sequence[current_phase_index]);
};

/// Démarre un tour pour le joueur donné, puis entre en phase de pioche.
start_turn = function (_player_id) {
    turn_player_id = _player_id;
    get_player(turn_player_id).has_played_creature = false;
    current_phase_index = 0;
    enter_phase(phase_sequence[current_phase_index]);
};

// --------------------------------------------------
// Initialisation des joueurs + decks
// --------------------------------------------------
player_a = Player_Create(PlayerId.PlayerA);
player_b = Player_Create(PlayerId.PlayerB);

var user_deck_source   = variable_global_exists("main_deck") ? global.main_deck : undefined;
var opps_deck_source   = variable_global_exists("opponent_deck") ? global.opponent_deck : user_deck_source;

player_a.deck = build_deck_from_source(user_deck_source, "PlayerA");
player_b.deck = build_deck_from_source(opps_deck_source, "PlayerB");

with (odeck) {
    register_with_controller(other);
}

with (oHand) {
    register_with_controller(other);
}

setup_starting_hand(player_a);
setup_starting_hand(player_b);

// Ouvre une fenêtre de mulligan avant le premier tour
open_mulligan_window();
