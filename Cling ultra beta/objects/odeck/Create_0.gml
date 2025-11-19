/// Gestion visuelle d'un deck en combat
cards = ds_list_create();
// `player_id` est réservé en GMS ; on utilise `owner_id` pour indiquer
// l'ID du joueur propriétaire de ce visuel de deck.
owner_id = (isThisP1) ? PlayerId.PlayerA : PlayerId.PlayerB;
controller = noone;
player_struct = undefined;
card_scale = 0.2;
card_layer = "Instances";
card_back = asset_get_index("Carte_Test");
if (card_back < 0) card_back = -1;

clear_cards = function () {
    for (var i = ds_list_size(cards) - 1; i >= 0; --i) {
        var inst = cards[| i];
        if (instance_exists(inst)) {
            if (variable_instance_exists(inst, "emprinte") && instance_exists(inst.emprinte)) {
                instance_destroy(inst.emprinte);
            }
            instance_destroy(inst);
        }
    }
    ds_list_clear(cards);
};

get_card_sprite = function (_info) {
    if (is_struct(_info) && variable_struct_exists(_info, "Carte_id")) {
        var spr = asset_get_index("Carte_" + string(_info.Carte_id));
        if (spr != -1) {
            return spr;
        }
    }
    return card_back;
};

create_card_instance = function (_info, _index) {
    var offset = _index / 3;
    var inst = instance_create_layer(x + offset, y, card_layer, oCardparent);
    inst.card_info = _info;
    inst.isThisP1 = isThisP1;
    inst.zone = "Deck";
    inst.image_angle = image_angle;
    inst.image_xscale = card_scale;
    inst.image_yscale = card_scale;
    inst.image_index = 1;
    inst.depth = -_index;

    var spr = get_card_sprite(_info);
    if (spr != -1) {
        inst.sprite_index = spr;
    }

    return inst;
};

rebuild_from_player_deck = function () {
    clear_cards();
    if (!is_struct(player_struct)) return;
    if (!ds_exists(player_struct.deck, ds_type_list)) return;

    for (var i = 0; i < ds_list_size(player_struct.deck); ++i) {
        var info = player_struct.deck[| i];
        var inst = create_card_instance(info, i);
        ds_list_add(cards, inst);
    }
};

pick_card_instance = function () {
    if (ds_list_size(cards) <= 0) return noone;
    var top_index = ds_list_size(cards) - 1;
    var inst = cards[| top_index];
    ds_list_delete(cards, top_index);
    return inst;
};

register_with_controller = function (_controller) {
    if (!instance_exists(_controller)) return;
    controller = _controller;
    player_struct = controller.get_player(owner_id);
    if (!is_struct(player_struct)) return;

    player_struct.deck_visual = id;
    rebuild_from_player_deck();
};
