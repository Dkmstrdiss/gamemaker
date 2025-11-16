function SearchSorter(Listo_filtered, Listo_filt_sorted)
{
	// Copier le contenu
	ds_list_clear(Listo_filt_sorted);
	for (var i = 0; i < ds_list_size(Listo_filtered); i++) {
	    ds_list_add(Listo_filt_sorted, Listo_filtered[| i]);
	}

	// Bubble sort
	var n = ds_list_size(Listo_filt_sorted);
	for (var i = 0; i < n - 1; i++) 
		{
		    for (var j = 0; j < n - i - 1; j++) 
			{
		        var card_a = Listo_filt_sorted[| j];
		        var card_b = Listo_filt_sorted[| j + 1];

		        var name_a = card_a.Name;
		        var name_b = card_b.Name;

		        var condition = (global.sorted == 0 && name_a > name_b) || (global.sorted == 1 && name_a < name_b);

		        if (condition) 
				{
		            // Échange
		            var temp = Listo_filt_sorted[| j];
		            Listo_filt_sorted[| j] = Listo_filt_sorted[| j + 1];
		            Listo_filt_sorted[| j + 1] = temp;
		        }
		    }
		}


}