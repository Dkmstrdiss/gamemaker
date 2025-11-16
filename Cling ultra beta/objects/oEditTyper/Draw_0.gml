if (global.show_warning_background) {
    var w = sprite_width * image_xscale;
    var h = sprite_height * image_yscale;
    draw_set_color(c_red);
    draw_rectangle(x - w/2 - 4, y - h/2 - 4, x + w/2 + 4, y + h/2 + 4, false);
    draw_set_color(c_white);
}

draw_self(); // Affiche la textbox

	draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
	draw_set_font(Font4);
if (focused) {

    // Position du curseur (en pixels)
    
    if (cursor_visible) {
    var substr = string_copy(global.text_inputEdit, 1, cursorPos);
    var cursor_x = tx + string_width(substr); // ici substr jusqu'à cursorPos
    draw_line(cursor_x, ty - 20, cursor_x, ty + 20);
    }
}

    draw_text(tx, ty, global.text_inputEdit);