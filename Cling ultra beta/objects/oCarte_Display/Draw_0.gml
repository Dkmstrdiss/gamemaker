

if (global.selected_card == Carte_info.Carte_id) {
    draw_set_color(c_yellow);
    draw_rectangle(x-4, y-4, x + sprite_width+4, y + sprite_height+4, false);
    draw_set_color(c_white);
	
}


draw_self();

