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

// If the Lecteur (deck reader) exists, ask it to populate slot globals
if (!is_undefined(Lecteur_Slot)) {
    // This will set `deck__slot_1` and `deck__slot_2` globals
    Lecteur_Slot(1);
    Lecteur_Slot(2);
}

// Assign decks from globals if present, otherwise create empty lists
player_a.deck = variable_global_exists("deck__slot_1") ? variable_global_get("deck__slot_1") : ds_list_create();
player_b.deck = variable_global_exists("deck__slot_2") ? variable_global_get("deck__slot_2") : ds_list_create();

// Run Preload_Fight to instantiate templates and load sprites
if (!is_undefined(Preload_Fight)) {
    preloaded_cards = Preload_Fight(id);
} else {
    preloaded_cards = undefined;
}

