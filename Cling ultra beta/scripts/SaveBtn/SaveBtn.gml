function SaveData(slot_id) {
                var save_dir = "Save data";

                if (!directory_exists(save_dir)) {
                    directory_create(save_dir);
                }

                var filename = save_dir + "/save_slot_" + string(slot_id) + ".txt";

		if (file_exists(filename)) {
		    file_delete(filename);
		}

		var f = file_text_open_write(filename);


    // Sauvegarder nom

   file_text_write_string(f, global.text_inputEdit);
	file_text_writeln(f);

 // Sauvegarder le main deck
   for (var i = 0; i < ds_list_size(global.main_deck); i++) {
       var card = global.main_deck[| i];
       file_text_write_string(f, string(card.Carte_id) + "," + string(card.Doublon));
		file_text_writeln(f);
   }

    file_text_close(f);
}
