if (global.slot_frame_mode != "delete") {
    
    global.slot_frame_mode = "delete";


    // Toggle du sprite du bouton entre 0 et 1
    if (image_index == 0) {
        image_index = 1;
    } else {
        image_index = 0;
    }

} else {
    
    global.slot_frame_mode = "selected";


    // Toggle retour du sprite
    if (image_index == 0) {
        image_index = 1;
    } else {
        image_index = 0;
    }
}