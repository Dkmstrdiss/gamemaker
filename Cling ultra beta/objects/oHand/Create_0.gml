/// oHand : gère l'affichage des cartes dans la main d'un joueur.
/// Chaque helper est commenté pour faciliter la prise en main.
cards = ds_list_create();
player_id = (isThisP1) ? PlayerId.PlayerA : PlayerId.PlayerB;
controller = noone;
player_struct = undefined;
card_layer = "Instances";
card_scale = 0.2;
card_object = asset_get_index("oCardparent");

// Bibliothèque de sprites : mise en cache et duplication du verso.
// Utilise un drapeau global pour ne définir les helpers qu'une fois, même si
// plusieurs mains ou decks sont créés dans la scène.
if (!variable_global_exists("__card_sprite_library_ready")) {
    global.__card_sprite_library_ready = true;

    function CardSpriteLibrary_Init() {
        if (!variable_global_exists("__card_sprite_cache")) {
            global.__card_sprite_cache = ds_map_create();
        }
        if (!variable_global_exists("__card_sprite_back")) {
            var back = asset_get_index("CarteBack");
            if (back < 0) {
                back = asset_get_index("Carte_Test");
            }
            global.__card_sprite_back = back;
        }
    }

    /// Renvoie le sprite du dos de carte, en initialisant le cache au besoin.
    function CardSpriteLibrary_GetBackSprite() {
        CardSpriteLibrary_Init();
        return global.__card_sprite_back;
    }

    /// Renvoie/compose le sprite (verso + recto) à partir de l'identifiant logique.
    function CardSpriteLibrary_GetSpriteFromId(_card_id) {
        CardSpriteLibrary_Init();
        var cache = global.__card_sprite_cache;
        if (is_undefined(_card_id)) {
            return CardSpriteLibrary_GetBackSprite();
        }

        var key = string(_card_id);
        if (ds_map_exists(cache, key)) {
            return cache[? key];
        }

        var front = asset_get_index("Carte_" + key);
        if (front == -1) {
            return CardSpriteLibrary_GetBackSprite();
        }

        var back = CardSpriteLibrary_GetBackSprite();
        var composed = -1;

        if (back != -1) {
            composed = sprite_duplicate(back);
            if (composed != -1) {
                sprite_add_from_sprite(composed, front, 0);
            }
        } else {
            composed = sprite_duplicate(front);
        }

        if (composed == -1) {
            return front;
        }

        sprite_set_offset(composed, sprite_get_xoffset(front), sprite_get_yoffset(front));
        ds_map_add(cache, key, composed);
        return composed;
    }

    /// Raccourci : accepte directement une struct carte (possédant Carte_id).
    function CardSpriteLibrary_GetSpriteFromInfo(_info) {
        if (!is_struct(_info)) {
            return CardSpriteLibrary_GetBackSprite();
        }
        if (!variable_struct_exists(_info, "Carte_id")) {
            return CardSpriteLibrary_GetBackSprite();
        }
        return CardSpriteLibrary_GetSpriteFromId(_info.Carte_id);
    }
}

CardSpriteLibrary_Init();
card_back = CardSpriteLibrary_GetBackSprite();

#region helpers
/// Crée visuellement une carte pour la main (sans la placer).
create_card_instance = function (_info) {
    if (card_object == -1) return noone;

    var inst = instance_create_layer(0, 0, card_layer, card_object);
    inst.card_info = _info;
    inst.isThisP1 = isThisP1;
    inst.zone = "Hand";

    var spr = -1;
    if (is_struct(_info) && variable_struct_exists(_info, "Carte_id")) {
        spr = asset_get_index("Carte_" + string(_info.Carte_id));
    }

    if (spr == -1) {
        spr = card_back;
    }

    inst.sprite_index = spr;
    inst.image_speed = 0;
    inst.image_index = 0;
    inst.image_xscale = card_scale;
    inst.image_yscale = card_scale;

    return inst;
};

/// Détruit les instances visuelles existantes et purge la liste.
clear_cards = function () {
    for (var i = ds_list_size(cards) - 1; i >= 0; --i) {
        var card = cards[| i];
        if (instance_exists(card)) {
            if (variable_instance_exists(card, "emprinte") && instance_exists(card.emprinte)) {
                instance_destroy(card.emprinte);
            }
            instance_destroy(card);
        }
    }
    ds_list_clear(cards);
};

/// Reconstruit intégralement la main visuelle à partir des données joueur.
rebuild_from_player_hand = function () {
    clear_cards();

    if (!is_struct(player_struct)) return;
    if (!ds_exists(player_struct.hand, ds_type_list)) return;

    for (var i = 0; i < ds_list_size(player_struct.hand); ++i) {
        var card_info = player_struct.hand[| i];
        var inst = create_card_instance(card_info);
        if (instance_exists(inst)) {
            ds_list_add(cards, inst);
        }
    }

    updateDisplay();
};

/// Mémorise le contrôleur (oGameController) et sa struct joueur associée.
register_with_controller = function (_controller) {
    if (!instance_exists(_controller)) return;
    controller = _controller;
    player_struct = controller.get_player(player_id);
    if (!is_struct(player_struct)) return;
    player_struct.hand_visual = id;
    rebuild_from_player_hand();
};

/// Ajoute une carte à partir d'une struct d'info (provenant du modèle de jeu).
add_card_from_info = function (_info) {
    if (!is_struct(_info)) return;
    var inst = create_card_instance(_info);
    if (instance_exists(inst)) {
        addcard(inst);
    }
};
#endregion

#region function addcard
/// Ajoute une carte visuelle à la liste et rafraîchit l'éventail.
addcard = function (card) {
    if (!instance_exists(card)) return;
    ds_list_add(cards, card);
    updateDisplay();
}
#endregion

#region function updateDisplay
/// Met à jour la position, l'angle et l'empreinte de chaque carte dans la main.
updateDisplay = function () {
    var count = ds_list_size(cards);
    if (count == 0) return;

    // Espacement et éventail dynamiques
    var spacing = clamp(90 - count * 4, 30, 90);
    var ouverture = clamp(12 - count, 4, 12);

    var base_x = 960;
    var base_y = (isThisP1) ? 1060 : 20;
    var offset = -((count - 1) * spacing) / 2;

    for (var i = 0; i < count; i++) {
        var card = ds_list_find_value(cards, i);
        if (!instance_exists(card)) continue;

        var index_centered = i - (count - 1) / 2;

        var angle_offset = index_centered * ouverture;
        var offset_y = 6 - sqr(index_centered) * 2;

        // Positionnement carte
        card.x = base_x + offset + i * spacing;
        card.y = base_y + (isThisP1 ? -offset_y : offset_y);
        card.zone = "Hand";
        card.image_index = 0;
        card.image_angle = isThisP1 ? -angle_offset : angle_offset;
        card.image_xscale = card_scale;
        card.image_yscale = card_scale;

        // Assure que la carte a une profondeur paire
        card.depth = -1000 - i * 2;

        // Création et association de l’empreinte si absente
        if (!variable_instance_exists(card, "emprinte") || !instance_exists(card.emprinte)) {
            card.emprinte = instance_create_layer(0, 0, "Instances", oEmprinte);
            card.emprinte.visible = false;
            card.emprinte.owner = card;
        }

        // Mise à jour de l’empreinte
        var emp = card.emprinte;
        emp.x = card.x;
        emp.y = card.y;
        emp.image_angle = card.image_angle;
        emp.image_xscale = card.image_xscale;
        emp.image_yscale = card.image_yscale;
        emp.depth = card.depth - 1; // empreinte en dessous
    }
}
#endregion
