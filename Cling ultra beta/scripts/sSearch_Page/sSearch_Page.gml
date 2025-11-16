function Refresh_Search_Page (Lista) {

    var TempSelected = "";
    // Supprimer les anciennes cartes
    with (oCarte_Display) {
        TempSelected = global.selected_card;
        instance_destroy();
    }

    with (oMiniLike) {
        instance_destroy();
    }

    // Paramètres
    var builder = instance_find(oBtnBuilder, 0);
    var cols = 4;
    var rows = 4;
    var scale = 0.13;
    var margin = 20;          // marge gauche, droite, haut
    var margin_bottom = 65;   // marge bas spécifique
    var per_page = cols * rows;
    var start_index = (builder.SearchPage1 - 1) * per_page;

    // Dimensions du conteneur
    var zone_w = sprite_get_width(oDisplay_Search_contener.sprite_index);
    var zone_h = sprite_get_height(oDisplay_Search_contener.sprite_index);

    // Sprite de référence
    var spr_test = asset_get_index("Carte_Test");
    var card_w = sprite_get_width(spr_test) * scale;
    var card_h = sprite_get_height(spr_test) * scale;

    // Zone utile
    var usable_w = zone_w - margin * 2;
    var usable_h = zone_h - margin - margin_bottom;

    // Espacement
    var spacing_x = (usable_w - (card_w * cols)) / (cols - 1);
    var spacing_y = (usable_h - (card_h * rows)) / (rows - 1);

    // Point de départ (haut gauche)
    var grid_x = oDisplay_Search_contener.x - (zone_w / 2) + margin;
    var grid_y = oDisplay_Search_contener.y - (zone_h / 2) + margin;

    // Placement des cartes
    for (var i = 0; i < per_page; i++) {
        var index = start_index + i;
        if (index >= ds_list_size(Lista)) break;

        var entry = Lista[| index];

        var card;      // template complet (Name, Genre, etc.)
        var Carte_id;  // identifiant numérique pour le sprite/favoris

        // -------- Résolution de card / Carte_id selon le type d'entrée --------
        if (is_struct(entry)) {

            // Cas deck slot : { Carte_id, Doublon, Carte_info }
            if (variable_struct_exists(entry, "Carte_info")) {
                Carte_id = entry.Carte_id;
                card     = entry.Carte_info;
            }
            // Cas template direct
            else {
                card = entry;

                if (variable_struct_exists(card, "Carte_id")) {
                    Carte_id = card.Carte_id;
                } else if (variable_struct_exists(card, "card_id")) {
                    Carte_id = card.card_id;
                } else if (variable_struct_exists(card, "id")) {
                    Carte_id = card.id;
                } else {
                    show_debug_message("Refresh_Search_Page: entrée sans Carte_id (index " + string(index) + ")");
                    continue;
                }
            }
        } else {
            // Cas où l'entrée est un simple id numérique
            Carte_id = entry;

            // À adapter si tes templates sont dans global.Listz au lieu de global.card_db
            card = global.card_db[Carte_id];
            if (!is_struct(card)) {
                show_debug_message("Refresh_Search_Page: card_db[" + string(Carte_id) + "] invalide");
                continue;
            }
        }

        // ----------------------------------------------------------------------

        var spr = asset_get_index("Carte_" + string(Carte_id));

        var col = i mod cols;
        var row = i div cols;
        var pos_x = grid_x + col * (card_w + spacing_x);
        var pos_y = grid_y + row * (card_h + spacing_y);

        var inst = instance_create_layer(pos_x, pos_y, "btn", oCarte_Display);
        inst.sprite_index = spr;
        inst.image_xscale = scale;
        inst.image_yscale = scale;
        inst.Carte_info   = card;

        global.selected_card = TempSelected;

        // Vérifie si la carte est likée
        if (ds_list_find_index(global.liked_cards, Carte_id) != -1) {
            var like_x = inst.x + (card_w) - 10;
            var like_y = inst.y + (card_h) - 10;

            var heart = instance_create_layer(like_x, like_y, "bonus", oMiniLike);
        }
    }
}


	
