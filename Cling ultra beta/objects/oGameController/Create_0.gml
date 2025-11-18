/// oGameController : contrôle principal du duel
/// - Instancie les joueurs
/// - Construit/mélange les decks
/// - Donne la main de départ (+ support mulligan)
/// - Gère la machine d'état des phases

// --------------------------------------------------
// Paramètres généraux
// --------------------------------------------------
Mode_Init();

starting_hand_size   = 5;
turn_player_id       = PlayerId.PlayerA;
turn_count           = 1;
auto_advance_phases  = true;
phase_sequence       = [Phase.Draw, Phase.Main, Phase.Attack, Phase.Defense, Phase.Resolution, Phase.End];
current_phase_index  = 0;
current_phase        = phase_sequence[current_phase_index];
phase_timer          = 0;

// --------------------------------------------------
// Helpers
// --------------------------------------------------
get_player = function (_id) {
    return (_id == PlayerId.PlayerA) ? player_a : player_b;
};

build_deck_from_source = function (_deck_source, _label) {
    var built = ds_list_create();

    var add_card = function (_card_info, _copies) {
        if (!is_struct(_card_info)) return;
        var copies = max(1, _copies);
        for (var c = 0; c < copies; ++c) {
            ds_list_add(built, _card_info);
        }
    };

    if (ds_exists(_deck_source, ds_type_list)) {
        for (var i = 0; i < ds_list_size(_deck_source); ++i) {
            var entry     = _deck_source[| i];
            var copies    = (is_struct(entry) && variable_struct_exists(entry, "Doublon")) ? entry.Doublon : 1;
            var card_info = (is_struct(entry) && variable_struct_exists(entry, "Carte_info")) ? entry.Carte_info : entry;
            add_card(card_info, copies);
        }
    } else if (is_array(_deck_source)) {
        for (var j = 0; j < array_length(_deck_source); ++j) {
            var arr_entry = _deck_source[j];
            add_card(arr_entry, 1);
        }
    }

    // Fallback : piocher quelques cartes depuis la base si le deck est vide
    if (ds_list_size(built) == 0 && is_array(global.card_db)) {
        for (var k = 0; k < array_length(global.card_db); ++k) {
            var template = global.card_db[k];
            if (is_struct(template)) {
                ds_list_add(built, template);
            }
            if (ds_list_size(built) >= 20) break;
        }
    }

    // Fallback ultime : deck de placeholders pour éviter les plantages
    if (ds_list_size(built) == 0) {
        var placeholder = {
            card_id    : -1,
            Name       : "Placeholder",
            Type       : CardType.Creature,
            Att        : 1,
            Def        : 1,
            Prod       : 0,
            Description: "Deck par défaut (aucune carte trouvée)",
            IsLegendary: false,
            IsToken    : false
        };
        repeat (20) ds_list_add(built, placeholder);
    }

    ds_list_shuffle(built);
    return built;
};

draw_card = function (_player) {
    if (!ds_exists(_player.deck, ds_type_list)) return undefined;
    if (ds_list_size(_player.deck) <= 0) return undefined;

    var top_index = ds_list_size(_player.deck) - 1;
    var card_info = _player.deck[| top_index];
    ds_list_delete(_player.deck, top_index);
    ds_list_add(_player.hand, card_info);
    return card_info;
};

draw_cards = function (_player, _count) {
    var drawn = 0;
    for (var i = 0; i < _count; ++i) {
        if (is_undefined(draw_card(_player))) break;
        drawn += 1;
    }
    return drawn;
};

setup_starting_hand = function (_player) {
    var drawn = draw_cards(_player, starting_hand_size);
    _player.starting_hand_size = drawn;
    _player.mulligan_available = true;
    _player.mulligan_used = false;
};

perform_mulligan = function (_player) {
    if (!_player.mulligan_available || _player.mulligan_used) return 0;

    var hand_size = ds_list_size(_player.hand);
    for (var i = hand_size - 1; i >= 0; --i) {
        var card = _player.hand[| i];
        ds_list_delete(_player.hand, i);
        ds_list_add(_player.deck, card);
    }

    ds_list_shuffle(_player.deck);
    var drawn = draw_cards(_player, hand_size);
    _player.mulligan_used = true;
    return drawn;
};

phase_duration = function (_phase) {
    switch (_phase) {
        case Phase.Draw:       return 0.35;
        case Phase.Main:       return 1.25;
        case Phase.Attack:     return 0.85;
        case Phase.Defense:    return 0.85;
        case Phase.Resolution: return 0.6;
        case Phase.End:        return 0.45;
    }
    return 0.75;
};

enter_phase = function (_phase) {
    current_phase = _phase;
    phase_timer   = 0;

    switch (_phase) {
        case Phase.Draw:
            draw_cards(get_player(turn_player_id), 1);
            break;
        case Phase.End:
            get_player(turn_player_id).has_played_creature = false;
            break;
    }
};

advance_phase = function () {
    current_phase_index += 1;

    if (current_phase_index >= array_length(phase_sequence)) {
        current_phase_index = 0;
        turn_count += 1;
        turn_player_id = (turn_player_id == PlayerId.PlayerA) ? PlayerId.PlayerB : PlayerId.PlayerA;
    }

    enter_phase(phase_sequence[current_phase_index]);
};

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

setup_starting_hand(player_a);
setup_starting_hand(player_b);

// Par défaut, on enchaîne directement sur le premier tour
player_a.mulligan_available = false;
player_b.mulligan_available = false;
start_turn(turn_player_id);
