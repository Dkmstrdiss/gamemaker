function Refresh_Main_Deck(ListDeck) {
    // Nettoyage
    with (oCarte_MainDeck_Display) instance_destroy();
    with (oCardCompteur) instance_destroy();

    // Paramètres
    var builder = instance_find(oBtnBuilder, 0);
    var cols_main = 8, rows_main = 5, scale_main = 0.09;
    var cols_sec = 5, rows_sec = 1, scale_sec = 0.1;
    var margin = 20, margin_bottom = 30, margin_sec =100;

    var per_page_main = cols_main * rows_main;
    var start_index = (builder.SearchPage2 - 1) * per_page_main;

    // Zones
    var zone_main = instance_find(oMain_deck_contener, 0);
    var zone_sec = instance_find(oSecondary_deck_contener, 0);
    if (!instance_exists(zone_main) || !instance_exists(zone_sec)) return;

    // Dimensions des cartes
    var card_spr = asset_get_index("Carte_Test");
    var card_w_main = sprite_get_width(card_spr) * scale_main;
    var card_h_main = sprite_get_height(card_spr) * scale_main;
    var card_w_sec = sprite_get_width(card_spr) * scale_sec;
    var card_h_sec = sprite_get_height(card_spr) * scale_sec;

    // Grille principale
    var usable_w_main = sprite_get_width(zone_main.sprite_index) - margin * 2;
    var usable_h_main = sprite_get_height(zone_main.sprite_index) - margin - margin_bottom;
    var spacing_x_main = (usable_w_main - (card_w_main * cols_main)) / (cols_main - 1);
    var spacing_y_main = (usable_h_main - (card_h_main * rows_main)) / (rows_main - 1);
    var grid_x_main = zone_main.x - sprite_get_width(zone_main.sprite_index) / 2 + margin;
    var grid_y_main = zone_main.y - sprite_get_height(zone_main.sprite_index) / 2 + margin;

    // Grille secondaire
    var spacing_x_sec = 20;
    var grid_x_sec = zone_sec.x - sprite_get_width(zone_sec.sprite_index) / 2 + margin_sec;
    var grid_y_sec = zone_sec.y - sprite_get_height(zone_sec.sprite_index) / 2 + margin;

    // Initialisation
    var total_count = 0;
    var i_sec = 0;
    var i_main = 0;

    for (var i = 0; i < ds_list_size(ListDeck); i++) {
        var card = ListDeck[| i];
        var Carte_id = card.Carte_id;
        var genre = card.Genre;
        var count = card.Doublon;

        var spr = asset_get_index("Carte_" + string(Carte_id));
        if (spr == -1) continue;

        if (genre == "Fusion") {
            var pos_x = grid_x_sec + i_sec * (card_w_sec + spacing_x_sec);
            var inst = instance_create_layer(pos_x, grid_y_sec, "btn", oCarte_MainDeck_Display);
            inst.sprite_index = spr;
            inst.image_xscale = scale_sec;
            inst.image_yscale = scale_sec;
            inst.Carte_info = card;

            // Ajout du compteur si doublon
            if (count > 1) {
                var dx = inst.x + sprite_get_width(spr) * inst.image_xscale * 0.85;
                var dy = inst.y + sprite_get_height(spr) * inst.image_yscale * 0.85;
                var compteur = instance_create_layer(dx, dy, "bonus", oCardCompteur);
                compteur.texte = "x" + string(count);
            }

            i_sec += 1;
        } else {
            if (i_main >= start_index && i_main < start_index + per_page_main) {
                var display_index = i_main - start_index;
                var col = display_index mod cols_main;
                var row = display_index div cols_main;
                var pos_x = grid_x_main + col * (card_w_main + spacing_x_main);
                var pos_y = grid_y_main + row * (card_h_main + spacing_y_main);

                var inst = instance_create_layer(pos_x, pos_y, "btn", oCarte_MainDeck_Display);
                inst.sprite_index = spr;
                inst.image_xscale = scale_main;
                inst.image_yscale = scale_main;
                inst.Carte_info = card;

                if (count > 1) {
                    var dx = inst.x + sprite_get_width(spr) * inst.image_xscale *0.85 ;
                    var dy = inst.y + sprite_get_height(spr) * inst.image_yscale *0.85;
                    var compteur = instance_create_layer(dx, dy, "bonus", oCardCompteur);
                    compteur.texte = "x" + string(count);
                }
            }
            i_main += 1;
			total_count += card.Doublon;
        }

        
    }

    // Affichage du compteur global
    if (instance_exists(oDeckCompteur)) {
        oDeckCompteur.texte = string(total_count);
    }
}
