// Suivre la souris avec offset
x = device_mouse_x(0) + drag_offset_x;
y = device_mouse_y(0) + drag_offset_y;

with (oCarte_Display) {
    if (inside_card) {
        oCarte_Clone.visible = true;

    }
}

with (oCarte_MainDeck_Display) {
    if (inside_card) {
        oCarte_Clone.visible = true;

    }
}



if (mouse_check_button_released(mb_left)) {
    var target_zone;

    // Déterminer la zone selon les conditions
    if (grabbed_in_search) {
        target_zone = instance_find(oDeckContener, 0);
    } else if (Carte_info.Genre == "Fusion") {
        target_zone = instance_find(oSecondary_deck_contener, 0);
    } else {
        target_zone = instance_find(oMain_deck_contener, 0);
    }

    var in_zone = false;

    if (instance_exists(target_zone)) {
        var zx = target_zone.x;
        var zy = target_zone.y;
        var sw = sprite_get_width(target_zone.sprite_index);
        var sh = sprite_get_height(target_zone.sprite_index);

        var left   = zx - sw * 0.5;
        var right  = zx + sw * 0.5;
        var top    = zy - sh * 0.5;
        var bottom = zy + sh * 0.5;

        in_zone = point_in_rectangle(x, y, left, top, right, bottom);
    }

    var found = false;

    if (in_zone && grabbed_in_search) {
        // Ajouter ou incrémenter
        for (var i = 0; i < ds_list_size(global.main_deck); i++) {
            var c = global.main_deck[| i];
            if (c.Carte_id == Carte_info.Carte_id) {
                c.Doublon += 1;
                found = true;
                break;
            }
        }

        if (!found) {
            Carte_info.Doublon = 1;
            ds_list_add(global.main_deck, Carte_info);
        }

    } else if (!in_zone && !grabbed_in_search) {
        // Supprimer ou décrémenter
        for (var i = 0; i < ds_list_size(global.main_deck); i++) {
            var c = global.main_deck[| i];
            if (c.Carte_id == Carte_info.Carte_id) {
                c.Doublon -= 1;
                if (c.Doublon <= 0) ds_list_delete(global.main_deck, i);
                break;
            }
        }
    }

    // Cas d’un simple clic sans effet (dans la zone mais pas drag depuis Search)
    if (in_zone && !grabbed_in_search) {
        instance_destroy(); // détruire le clone
        exit;
    }

    // Rafraîchissement
    Sort_Deck_By_Genre(global.main_deck, global.sorted_main_deck);
    Refresh_Main_Deck(global.sorted_main_deck);
    instance_destroy();
}
