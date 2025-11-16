var mx = device_mouse_x(0);
var my = device_mouse_y(0);

// Zone cliquable (origine haut-gauche ici)
var left = x;
var top = y;
var right = x + sprite_width ;
var bottom = y + sprite_height ;

// Détection actuelle
var is_over = (mx >= left && mx <= right && my >= top && my <= bottom);

// Détection de sortie
inside_card = (hover_was_over && !is_over);

// Mise à jour pour frame suivante
hover_was_over = is_over;
