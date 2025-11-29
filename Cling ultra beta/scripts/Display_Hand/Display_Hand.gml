function updateDisplay(_player, _isP1, _scale) {
    if (!is_struct(_player)) return;
    if (!ds_exists(_player.hand_visual, ds_type_list)) return;

    var cards = _player.hand_visual;
    var count = ds_list_size(cards);
    if (count == 0) return;

    var spacing   = clamp(110 - count * 3, 40, 130);   // plus espacé
    var ouverture = clamp(12 - count, 4, 12);

    // Room-space view center (camera 0). Adjust if you use multiple views.
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var base_x = view_x + view_w * 0.5;
    var base_y = _isP1 ? (view_y + view_h - 80) : (view_y + 80); // bottom/top margin

    var offset = -((count - 1) * spacing) / 2;

    for (var i = 0; i < count; i++) {
        var card = cards[| i];
        if (!instance_exists(card)) continue;

        var index_centered = i - (count - 1) / 2;
        var angle_offset = index_centered * ouverture;
        var offset_y = 6 - sqr(index_centered) * 2;

        // Apply X and Y with curvature
        card.x = base_x + offset + i * spacing;
        card.y = base_y + (_isP1 ? -offset_y : offset_y);

        card.zone = "Hand";
        card.image_index = 0;
        card.image_angle = _isP1 ? -angle_offset : angle_offset;

        if (!is_undefined(_scale)) {
            card.image_xscale = _scale;
            card.image_yscale = _scale;
        }

        card.target_depth = -1000 - i * 2;

        if (!variable_instance_exists(card, "emprinte") || !instance_exists(card.emprinte)) {
            card.emprinte = instance_create_layer(0, 0, "Instances", oEmprinte);
            card.emprinte.visible = false;
            card.emprinte.owner = card;
        }

        var emp = card.emprinte;
        emp.x = card.x;
        emp.y = card.y;
        emp.image_angle = card.image_angle;
        if (!is_undefined(_scale)) {
            emp.image_xscale = card.image_xscale;
            emp.image_yscale = card.image_yscale;
        }
        emp.depth = card.target_depth - 1;
    }
}