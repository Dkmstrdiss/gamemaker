image_index = (image_index == 0) ? 1 : 0;

// Si champ vide : affiche fond d'avertissement
if (string_length(global.text_inputEdit) <= 0) {
    image_index = 0;
    global.show_warning_background = true;
    exit;
} else {
    
    // Appel de la fonction SaveData avec le slot sélectionné

            SaveData(global.selected_slot);
			with(oEmptySlotOff){
			Lecteur_Slot(global.selected_slot);
			}
      global.slot_frame_mode = "save";
	                

}