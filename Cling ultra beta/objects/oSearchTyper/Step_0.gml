if (focused) 
{
		
	    // Ajout du texte tapé
	    if (keyboard_string != "") 
		{
			var t = keyboard_string;
	        global.text_input = string_insert(t, global.text_input, cursorPos+1);
			
	        cursorPos += string_length(t);
			SearchFilter(global.Listo, global.Listo_filtered);
	        SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);
	        Refresh_Search_Page(global.Listo_filt_sorted);
		
	        keyboard_string = "";
	    }

			if (key_delay > 0) 
			{
			    key_delay -= 1;
			}

		// Backspace avec délai
		if (keyboard_check_pressed(vk_backspace) && cursorPos > 0 && key_delay <= 0) 
		{
		    global.text_input = string_delete(global.text_input, cursorPos, 1);
		    cursorPos -= 1;

		    SearchFilter(global.Listo, global.Listo_filtered);
		    SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);
		    Refresh_Search_Page(global.Listo_filt_sorted);

		    key_delay = 6; // 6 frames de délai (ajuste selon besoin)
		}

	    // Déplacement curseur
	    if (keyboard_check_pressed(vk_left) && cursorPos > 0) cursorPos -= 1;
	    if (keyboard_check_pressed(vk_right) && cursorPos < string_length(global.text_input)) cursorPos += 1;

	    // Curseur clignotant
	    cursor_timer += 1;
	    if (cursor_timer > 30) 
		{
	        cursor_visible = !cursor_visible;
	        cursor_timer = 0;
	    }
}



