

if (mouse_check_button_pressed(mb_left)) 
{
    for (var i = 0; i < array_length(genre_list); i++) 
	{
        var box = item_boxes[i]; // [left, top, right, bottom]

        if (mouse_x >= box[0] && mouse_x <= box[2] && mouse_y >= box[1] && mouse_y <= box[3]) 
		{

            global.selected_genre = genre_list[i];

            SearchFilter(global.Listo, global.Listo_filtered);
            SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);
            Refresh_Search_Page(global.Listo_filt_sorted);
            break;
        }
    }
	
 inst_Filtre.image_index = 0;    // Fermer menu

global.dropdown_just_closed = true;
instance_destroy();

}

			



