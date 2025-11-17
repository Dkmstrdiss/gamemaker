function Lecteur_carte() {
    var file_path = "Liste_Carte.csv";
    if (!file_exists(file_path)) {
        show_debug_message("[Lecteur_carte] Fichier introuvable : " + file_path);
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
                id           : card_id,
                card_id      : card_id,
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
                Doublon      : 0
            };

            global.card_db[card_id] = template;
        }
    }

    file_text_close(file);

    global.Listo = global.card_db;
}

function Lecteur_Slot(Slot_id){
    var save_dir = "Save data";

    if (!directory_exists(save_dir)) {
        directory_create(save_dir);
    }

    var file_name = save_dir + "/save_slot_" + string(Slot_id) + ".txt";

    if (file_exists(file_name)) {
        var file = file_text_open_read(file_name);
        var list_deck = ds_list_create();

        var deck_name = file_text_readln(file);
        variable_global_set("deck_name_" + string(Slot_id), deck_name);

        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var parts = string_split(line, ",");
            if (array_length(parts) != 2) continue;

            var cardid = round(real(string_trim(parts[0])));
            var qty    = round(real(string_trim(parts[1])));

            var template = undefined;
            if (is_array(global.card_db) && cardid >= 0 && cardid < array_length(global.card_db)) {
                template = global.card_db[cardid];
            }

            if (is_struct(template)) {
                var entry = {
                    Carte_id : template.Carte_id,
                    Genre    : template.Genre,
                    Doublon  : qty,
                    Carte_info: template
                };
                ds_list_add(list_deck, entry);
            } else {
                show_debug_message("[Lecteur_Slot] Carte introuvable (id=" + string(cardid) + ")");
            }
        }

        file_text_close(file);

        variable_global_set("deck__slot_" + string(Slot_id), list_deck);

        if (is_array(global.slot_list) && Slot_id - 1 < array_length(global.slot_list)) {
            global.slot_list[Slot_id - 1].image_index = 2;
            global.slot_list[Slot_id - 1].is_used = true;
        }
    } else {
        variable_global_set("deck__slot_" + string(Slot_id), ds_list_create());

        if (is_array(global.slot_list) && Slot_id - 1 < array_length(global.slot_list)) {
            global.slot_list[Slot_id - 1].image_index = 0;
            global.slot_list[Slot_id - 1].is_used = false;
        }
    }
}