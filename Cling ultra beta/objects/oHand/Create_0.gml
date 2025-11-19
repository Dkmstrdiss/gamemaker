cards = ds_list_create();
// `player_id` est une variable read-only dans GameMaker, on utilise `owner_id`
// pour stocker l'ID du joueur propriétaire de cette instance visuelle.
owner_id = (isThisP1) ? PlayerId.PlayerA : PlayerId.PlayerB;
controller = noone;
player_struct = undefined;
card_layer = "Instances";
card_scale = 0.2;
card_back = asset_get_index("Carte_Test");
if (card_back < 0) card_back = -1;

#region helpers
get_card_sprite = function (_info) {
    if (is_struct(_info) && variable_struct_exists(_info, "Carte_id")) {
        var spr = asset_get_index("Carte_" + string(_info.Carte_id));
        if (spr != -1) {
            return spr;
        }
    }
    return card_back;
};

create_card_instance = function (_info) {
    var inst = instance_create_layer(0, 0, card_layer, oCardparent);
    inst.card_info = _info;
    inst.isThisP1 = isThisP1;
    inst.zone = "Hand";

    var spr = get_card_sprite(_info);
    if (spr != -1) {
        inst.sprite_index = spr;
    }
    inst.image_xscale = card_scale;
    inst.image_yscale = card_scale;

    return inst;
};

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

register_with_controller = function (_controller) {
    if (!instance_exists(_controller)) return;
    controller = _controller;
    // On demande la structure joueur au contrôleur en utilisant `owner_id`
    player_struct = controller.get_player(owner_id);
    if (!is_struct(player_struct)) return;
    player_struct.hand_visual = id;
};

add_card_from_info = function (_info) {
    if (!is_struct(_info)) return;
    var inst = create_card_instance(_info);
    if (instance_exists(inst)) {
        addcard(inst);
    }
};
#endregion

#region function addcard
addcard = function (card) {
    if (!instance_exists(card)) return;
    ds_list_add(cards, card);
    updateDisplay();
}
#endregion

#region function updateDisplay
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
        card.image_index = !isThisP1;
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
