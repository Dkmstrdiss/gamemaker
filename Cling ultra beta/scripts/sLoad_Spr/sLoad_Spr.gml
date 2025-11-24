function Preload_Fight_C() {
    // Force loading of all card sprites into memory by drawing them off-screen
    for (var _i = 1; _i <= 65; ++_i) {
        var spr = asset_get_index("Carte_" + string(_i));
		
        if (spr != -1) {
            draw_sprite(spr, 0, room_width/2, room_height/2);
			
        }
    }

}
