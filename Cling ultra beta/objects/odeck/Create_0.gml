/// Gestion visuelle d'un deck en combat
cards = ds_list_create();
player_id = (isThisP1) ? PlayerId.PlayerA : PlayerId.PlayerB;
controller = noone;
player_struct = undefined;
card_scale = 0.2;
card_layer = "Instances";

if (!function_exists(CardSpriteLibrary_Init)) {
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

    function CardSpriteLibrary_GetBackSprite() {
        CardSpriteLibrary_Init();
        return global.__card_sprite_back;
    }

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

create_card_instance = function (_info, _index) {
    var offset = _index / 3;
    var inst = instance_create_layer(x + offset, y, card_layer, oCardparent);
    inst.card_info = _info;
    inst.isThisP1 = isThisP1;
    inst.zone = "Deck";
    inst.image_angle = image_angle;
    inst.image_xscale = card_scale;
    inst.image_yscale = card_scale;
    inst.image_speed = 0;
    inst.image_index = 0;
    inst.depth = -_index;

    var spr = CardSpriteLibrary_GetSpriteFromInfo(_info);
    if (spr != -1) {
        inst.sprite_index = spr;
    } else {
        inst.sprite_index = card_back;
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
    player_struct = controller.get_player(player_id);
    if (!is_struct(player_struct)) return;

    player_struct.deck_visual = id;
    rebuild_from_player_deck();
};
