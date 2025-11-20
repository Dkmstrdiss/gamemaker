function Preload_Carte_Sprites() {

for (var i = 1; i <= 56; i++) {
    var spr = asset_get_index("Carte_" + string(i));
    if (spr != -1) {
        draw_sprite(spr, 0, -1000, -1000); // hors écran, force le chargement
    }
}

var back = asset_get_index("CarteBack");
if (back != -1) {
    draw_sprite(back, 0, -1000, -1000);
}
}
