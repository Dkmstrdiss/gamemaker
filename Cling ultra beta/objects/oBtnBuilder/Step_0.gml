var btn_list = [
    
    inst_LMDeck,
    inst_RMDeck,
    inst_LSDeck,
    inst_RSDeck,
    inst_RSearch,
    inst_LSearch,
	inst_Return,
	inst_Reset
];

// Initialisation si besoin
if (!variable_global_exists("clicked_btn")) {
    global.clicked_btn = noone;
}

// Gestion des clics
for (var i = 0; i < array_length(btn_list); i++) {
    var btn = btn_list[i];
    if (btn != noone) {
        var mx = mouse_x;
        var my = mouse_y;
        var half_w = btn.sprite_width * 0.5;
        var half_h = btn.sprite_height * 0.5;

        var is_hovered = point_in_rectangle(mx, my, btn.x - half_w, btn.y - half_h, btn.x + half_w, btn.y + half_h);

        if (mouse_check_button_pressed(mb_left) && is_hovered) {
            btn.image_index = 1;
            global.clicked_btn = btn;
        }

        if (global.clicked_btn == btn && mouse_check_button_released(mb_left)) 
		{
			
            btn.image_index = 0;
            global.clicked_btn = noone;

				    
				    // Gestion des clics de navigation
				    if (btn == inst_LSearch) 
					{
				        SearchPage1 = max(SearchPage1 - 1, 1); // minimum 1
						

					    	Refresh_Search_Page(global.Listo_filt_sorted);					 

				    }
				    else if (btn == inst_RSearch) {
				        SearchPage1 = min(SearchPage1 + 1, 10);
						

					   	Refresh_Search_Page(global.Listo_filt_sorted);
						
					
						
				    }
				 if (btn == inst_LMDeck) {
				        SearchPage2 = max(SearchPage2 - 1, 1); // minimum 1
				    }
				    else if (btn == inst_RMDeck) {
				        SearchPage2 += 1;
				    }
				if (btn == inst_Return)
				
					{
						SaveLikedCards();
					}	

				if (btn == inst_Reset)
				
					{
					    ResetLikedCards();
						ReadLikeManager();
						Refresh_Search_Page(global.Listo_filt_sorted);
					}
					
					
        }
    }
}
