// --- Initialisation ---

is_selected = false;
global.selected_slot = noone;
focused = false;
is_used = false;

// Chargement de la base de cartes
global.card_db = ds_list_create();
Lecteur_carte();

// Référencement des slots
global.slot_list = [inst_Empty_1, inst_Empty_2, inst_Empty_3];

// Initialisation des slots
for (var i = 0; i < array_length(global.slot_list); i++) {

    var slot = global.slot_list[i];
    slot.slot_id = i + 1;

    // Lecture et initialisation du slot
    var Slot_id = slot.slot_id;
    var file_name = "save_slot_" + string(Slot_id) + ".txt";

    if (file_exists(file_name)) {

        var file = file_text_open_read(file_name);
        var list_deck = ds_list_create();

        // Lecture du nom du deck
        var deck_name = file_text_readln(file);
        variable_global_set("deck_name_" + string(Slot_id), deck_name);

        // Lecture des cartes (id, qty)
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var parts = string_split(line, ",");

            if (array_length(parts) == 2) {
                var cardid = real(string_trim(parts[0]));
                var qty = real(string_trim(parts[1]));

                // Recherche de la carte
                for (var j = 0; j < ds_list_size(global.Listz); j++) {
                    var card = global.Listz[| j];
                    if (floor(card.Carte_id) == cardid) {
                        var entry = {
                            Carte_id: card.Carte_id,
                            Genre: card.Genre,
                            Doublon: qty,
                            Carte_info: card
                        };
                        ds_list_add(list_deck, entry);
                        break;
                    }
                }
            }
        }

        file_text_close(file);

        // Stockage du deck et marquage du slot
        variable_global_set("deck__slot_" + string(Slot_id), list_deck);
        slot.image_index = 2;
        slot.is_used = true;

    } else {
        // Slot vide
        variable_global_set("deck__slot_" + string(Slot_id), ds_list_create());
        slot.image_index = 0;
        slot.is_used = false;
    }
}
