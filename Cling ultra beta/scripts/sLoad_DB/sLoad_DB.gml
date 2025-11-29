function DataBase() {
    var file_path = "Liste_Carte.csv";
	
    if (!file_exists(file_path)) {
        show_message("[Lecteur_carte] Fichier introuvable : " + file_path);
        return;
    }

    var file = file_text_open_read(file_path);

    // Ignorer l'en-tête
    file_text_read_string(file);
    file_text_readln(file);

    global.card_db = [];

    var parse_int = function (val) {
        val = string_trim(val);
        return (string_digits(val) != "") ? round(real(val)) : 0;
    };

    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);

        if (string_length(string_trim(line)) == 0) continue;

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
            var card_id    = parse_int(fields[0]);
            var name       = fields[1];
            var type_str   = fields[2];
            var archetype  = fields[3];
            var att        = parse_int(fields[4]);
            var def        = parse_int(fields[5]);
            var prd        = parse_int(fields[6]);
            var effect_id  = fields[7];
            var desc       = fields[8];
            var is_leg     = (parse_int(fields[9]) != 0);
            var is_tok     = (parse_int(fields[10]) != 0);

            var type_enum;
            switch (type_str) {
                case "Creature": type_enum = CardType.Creature; break;
                case "Action":   type_enum = CardType.Action;   break;
                case "Fusion":   type_enum = CardType.Fusion;   break;
                default:          type_enum = CardType.Action;   break;
            }

            var template = {

                Carte_id     : card_id,
                Name         : name,
                Genre        : type_str,
                Type         : type_enum,
                Archetype    : archetype,
                Att          : att,
                Def          : def,
                Prod         : prd,
                EffectId     : effect_id,
                Description  : desc,
                IsLegendary  : is_leg,
                IsToken      : is_tok,
                Doublon      : 0,
				Numero		 : 0
            };

            global.card_db[card_id] = template;
        }
    }

    file_text_close(file);

}

function Deck_Slot(_slot_id) {
	

    var file_name ="save_slot_" + string(_slot_id) + ".txt";

    if (!file_exists(file_name)) {
        show_message("[Deck_Slot] Fichier introuvable : " + file_name);
        return;
    }

    var file      = file_text_open_read(file_name);
    var list_deck = ds_list_create();

    // 1ère ligne : nom du deck
    var deck_name = file_text_readln(file);
    variable_global_set("deck_name_" + string(_slot_id), deck_name);

    // Compteur pour numero d'entrée
    var numero = 0;

    while (!file_text_eof(file)) {
        var line = file_text_readln(file);
        line = string_trim(line);
        if (line == "") continue;

        var parts = string_split(line, ",");
        if (array_length(parts) != 2) continue;

        var cardid = round(real(string_trim(parts[0])));
        var qty    = round(real(string_trim(parts[1])));

        var template = undefined;
        if (is_array(global.card_db) && cardid >= 0 && cardid < array_length(global.card_db)) {
            template = global.card_db[cardid];
        }

        if (is_struct(template)) {
            // Ajouter `qty` exemplaires séparés dans la liste
            for (var n = 0; n < qty; ++n) {
                var entry = {
                    Carte_id   : template.Carte_id,
                    Genre      : template.Genre,
                    Carte_info : template
                   // Numero     : numero    // numéro d'entrée dans le deck
                };
                numero++; // incrémente pour la prochaine entrée
                ds_list_add(list_deck, entry);
            }
        } else {
            show_debug_message("[Deck_Slot] Carte introuvable (id=" + string(cardid) + ")");
        }
    }

    file_text_close(file);

    variable_global_set("deck_slot_" + string(_slot_id), list_deck);
}
