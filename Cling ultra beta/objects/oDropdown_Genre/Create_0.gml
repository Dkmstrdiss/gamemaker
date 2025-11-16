genre_list = Get_Genre_List_From_CSV();
item_height = 32;
selected = -1;
menu_x = x; // position réelle où on veut dessiner
menu_y = y;


draw_set_font(Font3); // nécessaire pour que string_width fonctionne
var max_width = 0;

for (var i = 0; i < array_length(genre_list); i++) 
{
    var w = string_width(genre_list[i]);
    if (w > max_width) max_width = w;
}

// Ajoute une marge visuelle à gauche/droite
menu_width = max_width;

// Stocke les hitbox rectangulaires de chaque option
item_boxes = array_create(array_length(genre_list));

for (var i = 0; i < array_length(genre_list); i++) {
    var tw = string_width(genre_list[i]);
    var th = item_height;

    var item_x = menu_x;
    var item_y = menu_y + i * item_height;

    var left   = item_x - tw * 0.5 - 10; // marge interne
    var right  = item_x + tw * 0.5 + 10;
    var top    = item_y - th * 0.5;
    var bottom = item_y + th * 0.5;

    item_boxes[i] = [left, top, right, bottom];
}