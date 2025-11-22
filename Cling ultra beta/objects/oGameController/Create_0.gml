/// Minimal oGameController Create: load decks from save slots and preload fight assets.

// Ensure enums and helpers are available (safe no-op if already initialized).
if (!is_undefined(Mode_Init)) Mode_Init();

// Create player structs
player_a = Player_Create(PlayerId.PlayerA);
player_b = Player_Create(PlayerId.PlayerB);

// Helper to load a slot into a global list using existing Lecteur_Slot
function load_slot_into_global(slot_id) {
    if (!is_undefined(Lecteur_Slot)) {
        Lecteur_Slot(slot_id);
    }
}

// Load the two default slots (assign slot 1 -> PlayerA, slot 2 -> PlayerB)
load_slot_into_global(1);
load_slot_into_global(2);

// Assign decks from globals if present, otherwise create empty lists
if (variable_global_exists("deck__slot_1")) {
    player_a.deck = variable_global_get("deck__slot_1");
} else {
    player_a.deck = ds_list_create();
}

if (variable_global_exists("deck__slot_2")) {
    player_b.deck = variable_global_get("deck__slot_2");
} else {
    player_b.deck = ds_list_create();
}

// Run Preload_Fight to instantiate templates and load sprites
if (!is_undefined(Preload_Fight)) {
    preloaded_cards = Preload_Fight(id);
} else {
    preloaded_cards = undefined;
}

