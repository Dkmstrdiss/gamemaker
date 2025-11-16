// --- Initialisation ---

is_selected = false;
global.selected_slot = noone;
focused = false;
is_used = false;

// Chargement de la base de cartes
if (!variable_global_exists("card_db")) {
    global.card_db = [];
}

if (!is_array(global.card_db) || array_length(global.card_db) == 0) {
    Lecteur_carte();
} else {
    global.Listo = global.card_db;
}

// Référencement des slots
global.slot_list = [inst_Empty_1, inst_Empty_2, inst_Empty_3];

// Initialisation des slots
for (var i = 0; i < array_length(global.slot_list); i++) {
    var slot = global.slot_list[i];
    slot.slot_id = i + 1;

    Lecteur_Slot(slot.slot_id);
}
