// Réinitialise le warning si texte rempli
if (global.show_warning_background && string_length(global.text_inputEdit) > 0) {
    global.show_warning_background = false;
}
if(global.slot_frame_mode == "save")
{
oFrameSlot.image_index = 1;
                if (delay_timer > 0) 
				{
				    delay_timer -= 1;

				    if (delay_timer <= 0) {
				        // Action à exécuter après le délai
				        oFrameSlot.image_index = 0;
						image_index = 0;
					global.slot_frame_mode = "libre";	
					delay_timer = 60;
				    }
				} // Retour à 0 dans 2 secondes
}


