function DeckLoader(_deck_source, _label) {
    var built = ds_list_create();

    var add_card = function (_card_info, _copies) {
        if (!is_struct(_card_info)) return;
        var copies = max(1, _copies);
        for (var c = 0; c < copies; ++c) {
            ds_list_add(built, _card_info);
        }
    };

    // Ajout depuis une ds_list (éditée dans le deckbuilder)
    if (ds_exists(_deck_source, ds_type_list)) {
        for (var i = 0; i < ds_list_size(_deck_source); ++i) {
            var entry     = _deck_source[| i];
            var copies    = (is_struct(entry) && variable_struct_exists(entry, "Doublon")) ? entry.Doublon : 1;
            var card_info = (is_struct(entry) && variable_struct_exists(entry, "Carte_info")) ? entry.Carte_info : entry;
            add_card(card_info, copies);
        }

    // Ajout depuis un simple tableau (ex. deck de test)
    } else if (is_array(_deck_source)) {
        for (var j = 0; j < array_length(_deck_source); ++j) {
            var arr_entry = _deck_source[j];
            add_card(arr_entry, 1);
        }
    }

    // Fallback : piocher quelques cartes depuis la base si le deck est vide
    if (ds_list_size(built) == 0 && variable_global_exists("card_db") && is_array(global.card_db)) {
        for (var k = 0; k < array_length(global.card_db); ++k) {
            var template = global.card_db[k];
            if (is_struct(template)) {
                ds_list_add(built, template);
            }
            if (ds_list_size(built) >= 20) break;
        }
    }

    // Fallback ultime : deck de placeholders pour éviter les plantages
    if (ds_list_size(built) == 0) {
        var placeholder = {
            card_id    : -1,
            Name       : "Placeholder",
            Type       : CardType.Creature,
            Att        : 1,
            Def        : 1,
            Prod       : 0,
            Description: "Deck par défaut (aucune carte trouvée)",
            IsLegendary: false,
            IsToken    : false
        };
        repeat (20) ds_list_add(built, placeholder);
    }

    ds_list_shuffle(built);
    return built;
}
