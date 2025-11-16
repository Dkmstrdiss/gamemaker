// Dessiner le rectangle
draw_self();


// Chercher l’instance de oBtnBuilder
var builder = instance_find(oBtnBuilder, 0);
if (builder != noone) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
	draw_set_font(FontMPage);
    draw_text(x, y,string(builder.SearchPage2));
}