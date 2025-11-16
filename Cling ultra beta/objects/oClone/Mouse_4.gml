// Bouton clone cliqué

// Vérifier qu’un deck est sélectionné

if (global.selected_slot != noone) {

    var empty_slots = [];

    // Recherche des slots non utilisés
    for (var i = 0; i < array_length(global.slot_list); i++) {
        var slot_inst = global.slot_list[i];

        if (!slot_inst.is_used) {
            array_push(empty_slots, slot_inst);
        }
    }

    // Cas 1 : aucun slot libre
    if (array_length(empty_slots) == 0) {
        
    }
    // Cas 2 : un seul slot libre → clonage direct
    else if (array_length(empty_slots) == 1) {

        var source_deck = variable_global_get("deck__slot_" + string(global.selected_slot));
        var source_deck_name = variable_global_get("deck_name_" + string(global.selected_slot));

		
		var base_name = string_trim(source_deck_name);
		var deck_name_try1 = base_name + "(1)";
		var deck_name_try2 = base_name + "(2)";

		var nom_existe = false;

		// Parcours des slots pour vérifier si un slot utilise déjà deck_name_try1
		for (var i = 0; i < array_length(global.slot_list); i++) {
		    var test_name = variable_global_get("deck_name_" + string(global.slot_list[i].slot_id));
    
		    if (test_name == deck_name_try1) {
		        nom_existe = true;
		        break;
		    }
		}

		// Choix du nom final
		var new_deck_name;

		if (nom_existe) {
		    new_deck_name = deck_name_try2;
		} else {
		    new_deck_name = deck_name_try1;
		}




        var dest_slot = empty_slots[0];
        var new_slot_id = dest_slot.slot_id;

        // Copier le deck
        var cloned_deck = ds_list_create();

        for (var j = 0; j < ds_list_size(source_deck); j++) {
            var card = source_deck[| j];

            // Cloner la structure
            var entry = {
                Carte_id: card.Carte_id,
                Genre: card.Genre,
                Doublon: card.Doublon,
                Carte_info: card.Carte_info
            };

            ds_list_add(cloned_deck, entry);
        }

        variable_global_set("deck__slot_" + string(new_slot_id), cloned_deck);
        
		variable_global_set("deck_name_" + string_trim(dest_slot.slot_id), new_deck_name);


        // Mettre à jour le slot visuellement
        dest_slot.is_used = true;
        dest_slot.image_index = 2;

        
    }
    // Cas 3 : plusieurs slots libres → mode clone
    else {
        global.slot_frame_mode = "clone";
       
    }

}
