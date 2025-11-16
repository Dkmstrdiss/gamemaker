// --- Initialisation protection ---
if (global.dropdown_just_closed && !mouse_check_button(mb_left)) {
    global.dropdown_just_closed = false;
}

// --- Liste des boutons avec comportement toggle ---
var btn_list = [inst_Filtre, inst_Favori, inst_TriDown, inst_Like];

for (var i = 0; i < array_length(btn_list); i++) {
    var btn = btn_list[i];
    if (!instance_exists(btn)) continue;

    var mx = mouse_x;
    var my = mouse_y;
    var half_w = btn.sprite_width * 0.5;
    var half_h = btn.sprite_height * 0.5;
    var is_hovered = point_in_rectangle(mx, my, btn.x - half_w, btn.y - half_h, btn.x + half_w, btn.y + half_h);

    if (mouse_check_button_pressed(mb_left) && is_hovered) {
        // === Cas inst_Filtre ===
        if (btn == inst_Filtre) {
            if (!global.dropdown_just_closed) {
                var drop = instance_create_layer(btn.x + btn.sprite_width + 30, btn.y + 30, "bonus", oDropdown_Genre);
                drop.source_button = btn;
                btn.image_index = 1;
            } else {
                global.dropdown_just_closed = true;
                with (oDropdown_Genre) instance_destroy();
                btn.image_index = 0;
            }
        }

        // === Cas inst_TriDown ===
        if (btn == inst_TriDown) {
            global.sorted = 1 - global.sorted;
            btn.image_index = global.sorted;
            SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);
            Refresh_Search_Page(global.Listo_filt_sorted);
        }
		
		if (btn == inst_Like) 
		{
		    WriteLikeManager(global.selected_card);
		    btn.image_index = 1 - btn.image_index; // toggle entre 0 et 1
			Refresh_Search_Page(global.Listo_filt_sorted);
		}

		if (btn == inst_Favori) 
		{
		    global.only_favorites = !global.only_favorites; // toggle entre 0 et 1
		    btn.image_index = global.only_favorites;         // 1 si activé, 0 sinon

		    SearchFilter(global.Listo, global.Listo_filtered);
		    SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);
		    Refresh_Search_Page(global.Listo_filt_sorted);
		}

		
    }
}
