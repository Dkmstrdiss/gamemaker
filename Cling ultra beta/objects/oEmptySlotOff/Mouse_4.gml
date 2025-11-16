

    // Cas 1 : Mode Clone actif
    if (global.slot_frame_mode == "clone") {

        if (!is_used) {
            // Clonage du deck sélectionné vers ce slot
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

            var new_slot_id = slot_id;
            var cloned_deck = ds_list_create();

            for (var j = 0; j < ds_list_size(source_deck); j++) {
                var card = source_deck[| j];

                var entry = {
                    Carte_id: card.Carte_id,
                    Genre: card.Genre,
                    Doublon: card.Doublon,
                    Carte_info: card.Carte_info
                };
                ds_list_add(cloned_deck, entry);
            }

            variable_global_set("deck__slot_" + string(new_slot_id), cloned_deck);
            variable_global_set("deck_name_" + string_trim(new_slot_id), new_deck_name);

            is_used = true;
            image_index = 2;

            global.slot_frame_mode = "libre";
            
        } else {
            show_message("Ce slot est déjà utilisé.");
        }

        exit;
    }

    // Cas 2 : Mode sélection classique

    if (global.slot_frame_mode == "libre")
	{

    // Désélectionner les autres slots
    for (var i = 0; i < array_length(global.slot_list); i++) {
        var slot_inst = global.slot_list[i];
        slot_inst.is_selected = false;
        slot_inst.image_index = slot_inst.is_used ? 2 : 0;
    }

    // Sélectionner celui-ci
    is_selected = true;
    global.selected_slot = slot_id;
    oFrameSlot.visible = true;
    oFrameSlot.x = x;
    oFrameSlot.y = y;

    global.main_deck = variable_global_get("deck__slot_" + string(slot_id));
    Refresh_Main_Deck(global.main_deck);

    if (!is_used) {
        image_index = 1;
        global.text_inputEdit = "";
    } else {
        image_index = 3;
        var deck_name = variable_global_get("deck_name_" + string(slot_id));
        global.text_inputEdit = deck_name;
    }
global.slot_frame_mode = "selected"
	}
	
    if (global.slot_frame_mode == "selected")
	{    
			 // Désélectionner les autres slots
		    for (var i = 0; i < array_length(global.slot_list); i++) {
		        var slot_inst = global.slot_list[i];
		        slot_inst.is_selected = false;
		        slot_inst.image_index = slot_inst.is_used ? 2 : 0;
		    }

		    // Sélectionner celui-ci
		    is_selected = true;
		    global.selected_slot = slot_id;
		    oFrameSlot.visible = true;
		    oFrameSlot.x = x;
		    oFrameSlot.y = y;

		    global.main_deck = variable_global_get("deck__slot_" + string(slot_id));
		    Refresh_Main_Deck(global.main_deck);

		    if (!is_used) {
		        image_index = 1;
		        global.text_inputEdit = "";
		    } else {
		        image_index = 3;
		        var deck_name = variable_global_get("deck_name_" + string(slot_id));
		        global.text_inputEdit = deck_name;
		    }
	}
	
	if (global.slot_frame_mode == "delete") {

    // Désélectionner les autres slots
    for (var i = 0; i < array_length(global.slot_list); i++) {
        var slot_inst = global.slot_list[i];
        slot_inst.is_selected = false;
        slot_inst.image_index = slot_inst.is_used ? 2 : 0;
    }

    // Sélection de celui-ci
    is_selected = true;
    global.selected_slot = slot_id;

    // Suppression du contenu
    if (global.selected_slot != noone) {

        var s_id = global.selected_slot;

        // Suppression du deck
        if (variable_global_exists("deck__slot_" + string(s_id))) {
            var deck = variable_global_get("deck__slot_" + string(s_id));
            
            if (ds_exists(deck, ds_type_list)) {
                ds_list_destroy(deck);
            }

            variable_global_set("deck__slot_" + string(s_id), ds_list_create());
        }

        // Suppression du nom
        variable_global_set("deck_name_" + string(s_id), "");

        // Marquage visuel
        var slot_inst = global.slot_list[s_id - 1];
        slot_inst.is_used = false;
        slot_inst.image_index = 0;

        if (global.main_deck != undefined && s_id == global.selected_slot) {
            ds_list_clear(global.main_deck);
            global.text_inputEdit = "";
        }

       
		oDeleteOff.image_index=0;
    }

    oFrameSlot.visible = true;
    oFrameSlot.x = x;
    oFrameSlot.y = y;
    image_index = 0;
	global.slot_frame_mode = "libre";
}
