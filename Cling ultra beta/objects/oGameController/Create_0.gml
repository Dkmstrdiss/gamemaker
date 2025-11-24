/// Minimal oGameController Create: load decks from save slots and preload fight assets.
//var target_w = 960;
//var target_h = 540;

//window_set_size(target_w, target_h);
// Ensure enums and helpers are available (safe no-op if already initialized).
Mode_Init();
//Preload_Fight_C();
DataBase();

// Create player structs
player_a = Player_Create(PlayerId.PlayerA);
player_b = Player_Create(PlayerId.PlayerB);


// If the Lecteur (deck reader) exists, ask it to populate slot globals
if (!is_undefined(Lecteur_Slot)) {
    // This will set `deck__slot_1` and `deck__slot_2` globals
    Deck_Slot(1);
	
	Deck_Slot(2);
}

// Assign decks from globals if present, otherwise create empty lists
player_a.deck = variable_global_exists("deck_slot_1") ? variable_global_get("deck_slot_1") : ds_list_create();
player_b.deck = variable_global_exists("deck_slot_2") ? variable_global_get("deck_slot_2") : ds_list_create();


InstCreate(player_a.deck);
player_a.deck_visual = InstCreate(player_a.deck);
instance_create_layer(0, 0, "Instances", odeck);
InstCreate(player_b.deck);




