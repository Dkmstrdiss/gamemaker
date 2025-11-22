// oGameMaster Create: initialize globals needed by oGameController

// Initialize mode constants and enums if available
if (!is_undefined(Mode_Init)) Mode_Init();

// Ensure card database is loaded (Lecteur_carte provided by sLecteur_Deck)
if (!variable_global_exists("card_db") && !is_undefined(Lecteur_carte)) {
    Lecteur_carte();
}

// Ensure a slot_list exists so Lecteur_Slot can safely index into it
if (!variable_global_exists("slot_list")) {
    global.slot_list = [];
}

// Ensure deck slot globals exist to avoid undefined reads later
if (!variable_global_exists("deck__slot_1")) variable_global_set("deck__slot_1", ds_list_create());
if (!variable_global_exists("deck__slot_2")) variable_global_set("deck__slot_2", ds_list_create());

// Optionally initialize deck names
if (!variable_global_exists("deck_name_1")) variable_global_set("deck_name_1", "");
if (!variable_global_exists("deck_name_2")) variable_global_set("deck_name_2", "");
