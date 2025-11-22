function Preload_Fight(_controller) {
    // Force loading of all card sprites into memory by drawing them off-screen
    for (var _i = 1; _i <= 56; ++_i) {
        var _spr = asset_get_index("Carte_" + string(_i));
        if (_spr != -1) {
            draw_sprite(_spr, 0, -99999, -99999);
        }
    }
    var layer_name = "Instances";
    if (layer_get_id(layer_name) == -1) {
        var existing_layers = layer_get_all();
        if (is_array(existing_layers) && array_length(existing_layers) > 0) {
            layer_name = layer_get_name(existing_layers[0]);
        }
    }

    var make_cards_from_deck = function (_deck, _owner_id) {
        var created = [];
        if (!ds_exists(_deck, ds_type_list)) return created;

        for (var i = 0; i < ds_list_size(_deck); ++i) {
            var entry = _deck[| i];
            var card_info = (is_struct(entry) && variable_struct_exists(entry, "Carte_info")) ? entry.Carte_info : entry;
            // Ensure we have a struct with a valid Carte_id before proceeding
            if (!is_struct(card_info) || !variable_struct_exists(card_info, "Carte_id")) continue;

            var copies = (is_struct(entry) && variable_struct_exists(entry, "Doublon")) ? entry.Doublon : 1;
            var sprite_name = "Carte_" + string(card_info.Carte_id);
            var sprite_idx = asset_get_index(sprite_name);
            if (sprite_idx == -1) {
                sprite_idx = asset_get_index("CarteBack");
            }

            repeat (max(1, copies)) {
                var inst = instance_create_layer(-10000, -10000, layer_name, oCarte);
                if (!instance_exists(inst)) continue;

                inst.Carte_info = card_info;
                inst.card_info  = card_info;
                inst.card_id    = card_info.Carte_id;
                inst.owner_id   = _owner_id;

                if (sprite_idx != -1) {
                    inst.sprite_index = sprite_idx;
                    inst.image_index  = 0;
                    inst.image_speed  = 0;
                }

                inst.visible = false;
                array_push(created, inst);
            }
        }

        return created;
    };

    var preload = {
        player_a : make_cards_from_deck(_controller.player_a.deck, PlayerId.PlayerA),
        player_b : make_cards_from_deck(_controller.player_b.deck, PlayerId.PlayerB)
    };

    _controller.preloaded_cards = preload;
    return preload;
}
