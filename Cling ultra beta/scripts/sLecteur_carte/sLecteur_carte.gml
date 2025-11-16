function Lecteur_carte() {
    var file = file_text_open_read("Liste_Carte.csv");

    // skip header
    file_text_read_string(file);
    file_text_readln(file);

    global.card_db = [];

    function parse_int(val) {
        val = string_trim(val);
        return (string_digits(val) != "") ? round(real(val)) : 0;
    }

    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);

        var fields = [];
        while (true) {
            var s = string_pos("[", line);
            var e = string_pos("]", line);
            if (s == 0 || e == 0 || e < s) break;
            var v = string_copy(line, s + 1, e - s - 1);
            array_push(fields, v);
            line = string_delete(line, 1, e);
        }

        if (array_length(fields) >= 11) {

            var card_id = parse_int(fields[0]);
            var name        = fields[1];
            var type_str    = fields[2];
            var archetype   = fields[3];
            var att         = parse_int(fields[4]);
            var def         = parse_int(fields[5]);
            var prd         = parse_int(fields[6]);
            var effect_id   = fields[7];
            var desc        = fields[8];
            var is_leg      = (parse_int(fields[9]) != 0);
            var is_tok      = (parse_int(fields[10]) != 0);

            var type_enum;
            switch (type_str) {
                case "Creature": type_enum = CardType.Creature; break;
                case "Action":   type_enum = CardType.Action;   break;
                case "Fusion":   type_enum = CardType.Fusion;   break;
                default:         type_enum = CardType.Action;   break;
            }

            global.card_db[id] = {
                id          : id,
                name        : name,
                type        : type_enum,
                archetype   : archetype,
                att_base    : att,
                def_base    : def,
                prd_base    : prd,
                is_legendary: is_leg,
                is_token    : is_tok,
                effect_id   : effect_id,
                description : desc
            };
        }
    }

    file_text_close(file);
}

function Lecteur_Slot(Slot_id){
		// --- Lecture du fichier du slot courant ---
		var file_name = "save_slot_" + string(Slot_id) + ".txt";

		if (file_exists(file_name)) {
		    var file = file_text_open_read(file_name);

		    var list_deck = ds_list_create(); // <- deck du slot (ds_list de struct)

		    // 1re ligne : nom du deck
		    var deck_name = file_text_readln(file);
		    if (Slot_id == 1) global.deck_name_1 = deck_name;
		    if (Slot_id == 2) global.deck_name_2 = deck_name;
		    if (Slot_id == 3) global.deck_name_3 = deck_name;

		    // Lecture des lignes suivantes : id,qty
		    while (!file_text_eof(file)) {
		        var line = file_text_readln(file);
		        var parts = string_split(line, ",");

		        if (array_length(parts) == 2) {
		            var cardid = real(string_trim(parts[0]));
		            var qty = real(string_trim(parts[1]));

		            // Recherche dans global.Listz (ds_list)
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

		    // Stocker le deck dans une variable globale dynamique
		    variable_global_set("deck__slot_" + string(Slot_id), list_deck);

		    // Marquage du slot comme utilisé
		    global.slot_list[Slot_id - 1].image_index = 2;
		    global.slot_list[Slot_id - 1].is_used = true;
		} else {
		    global.slot_list[Slot_id - 1].image_index = 0;
		    global.slot_list[Slot_id - 1].is_used = false;
		}
}