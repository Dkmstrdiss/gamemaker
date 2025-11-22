/// Minimal oGameController Create: load decks from save slots and preload fight assets.

// Ensure enums and helpers are available (safe no-op if already initialized).
if (!is_undefined(Mode_Init)) Mode_Init();

// Create player structs
player_a = Player_Create(PlayerId.PlayerA);
player_b = Player_Create(PlayerId.PlayerB);

// Load decks for Player A and Player B.
// Priority:
// 1) If `deck__slot_X` global exists (preloaded by other room), use it.
// 2) If a global deck source exists (`main_deck` / `opponent_deck`), use `sDeckLoader` on it.
// 3) Fallback: call `sDeckLoader` with an empty source so it applies internal fallbacks.

// Player A
if (variable_global_exists("deck__slot_1")) {
    player_a.deck = variable_global_get("deck__slot_1");
} else if (!is_undefined(sDeckLoader) && variable_global_exists("main_deck")) {
    player_a.deck = sDeckLoader(global.main_deck, "PlayerA");
} else if (!is_undefined(sDeckLoader)) {
    player_a.deck = sDeckLoader([], "PlayerA");
} else {
    player_a.deck = ds_list_create();
}

// Player B
if (variable_global_exists("deck__slot_2")) {
    player_b.deck = variable_global_get("deck__slot_2");
} else if (!is_undefined(sDeckLoader) && variable_global_exists("opponent_deck")) {
    player_b.deck = sDeckLoader(global.opponent_deck, "PlayerB");
} else if (!is_undefined(sDeckLoader) && variable_global_exists("main_deck")) {
    // fallback to main_deck for opponent if opponent_deck missing
    player_b.deck = sDeckLoader(global.main_deck, "PlayerB");
} else if (!is_undefined(sDeckLoader)) {
    player_b.deck = sDeckLoader([], "PlayerB");
} else {
    player_b.deck = ds_list_create();
}

// Run Preload_Fight to instantiate templates and load sprites
if (!is_undefined(Preload_Fight)) {
    preloaded_cards = Preload_Fight(id);
} else {
    preloaded_cards = undefined;
}

