// Dimensions du menu global
var w = menu_width;
var h = array_length(genre_list) * item_height;

// Fond noir du menu
draw_set_color(c_black);
draw_set_font(Font3);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_rectangle(x - w, y - ((item_height / 2) + 5), x + w, y + h-(item_height / 2), false); // rectangle rempli

// Boucle sur les entrées
for (var i = 0; i < array_length(genre_list); i++) {
    var box = item_boxes[i]; // [left, top, right, bottom]
    var text = genre_list[i];

    // Survol souris
    if (mouse_x >= box[0] && mouse_x <= box[2] &&
        mouse_y >= box[1] && mouse_y <= box[3]) {
        draw_set_color(make_color_rgb(200, 200, 200));
        draw_rectangle(box[0], box[1], box[2], box[3], false);
    }

    // Texte (toujours centré)
    draw_set_color(c_white);
    draw_text(menu_x, menu_y + i * item_height, text);
}

