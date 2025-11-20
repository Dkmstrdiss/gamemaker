/// Gestion visuelle d'un deck en combat : création, duplication et pioche.
cards = ds_list_create();
player_id = (isThisP1) ? PlayerId.PlayerA : PlayerId.PlayerB;
controller = noone;
player_struct = undefined;
card_scale = 0.2;
card_layer = "Instances";

// Bibliothèque de sprites partagée : cache le verso et compose les sprites dos+face.
// Utilise un nom de fonction en chaîne pour éviter les erreurs de variable non définie
// lorsque l'évènement est chargé.
if (!function_exists("CardSpriteLibrary_Init")) {
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

    /// Renvoie le sprite du dos (initialise le cache si nécessaire).
    function CardSpriteLibrary_GetBackSprite() {
        CardSpriteLibrary_Init();
        return global.__card_sprite_back;
    }

    /// Compose un sprite dos+face à partir de l'identifiant d'une carte.
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

    /// Raccourci : accepte une struct possédant le champ Carte_id.
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

/// Supprime les instances visuelles du deck et vide la liste interne.
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

/// Crée une instance de carte face verso pour représenter une pile de deck.
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

    inst.sprite_index = (card_back != -1) ? card_back : CardSpriteLibrary_GetBackSprite();

    return inst;
};

/// Reconstruit l'empilement visuel depuis la liste du deck joueur.
rebuild_from_player_deck = function () {
    clear_cards();
    var source_deck = variable_global_exists("main_deck") ? global.main_deck : undefined;
    if (!ds_exists(source_deck, ds_type_list) && is_struct(player_struct) && ds_exists(player_struct.deck, ds_type_list)) {
        source_deck = player_struct.deck;
    }

    if (!ds_exists(source_deck, ds_type_list)) return;

    var visual_index = 0;
    for (var i = 0; i < ds_list_size(source_deck); ++i) {
        var entry = source_deck[| i];
        var card_info = (is_struct(entry) && variable_struct_exists(entry, "Carte_info")) ? entry.Carte_info : entry;
        var copies = (is_struct(entry) && variable_struct_exists(entry, "Doublon")) ? entry.Doublon : 1;

        repeat (max(1, copies)) {
            var inst = create_card_instance(card_info, visual_index);
            ds_list_add(cards, inst);
            visual_index += 1;
        }
    }
};

/// Retire visuellement la carte du dessus et la renvoie à la main.
pick_card_instance = function () {
    if (ds_list_size(cards) <= 0) return noone;
    var top_index = ds_list_size(cards) - 1;
    var inst = cards[| top_index];
    ds_list_delete(cards, top_index);
    return inst;
};

/// Associe le deck visuel au contrôleur et reconstruit à partir des données modèle.
register_with_controller = function (_controller) {
    if (!instance_exists(_controller)) return;
    controller = _controller;
    player_struct = controller.get_player(player_id);
    if (!is_struct(player_struct)) return;

    player_struct.deck_visual = id;
    rebuild_from_player_deck();
};
