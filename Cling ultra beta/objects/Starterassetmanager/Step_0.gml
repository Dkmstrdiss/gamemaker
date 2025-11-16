
// ÉTAT 0 : fade-in de inst_pres
if (etat == 0) {
    if (fade_timer < fade_duration)
		{
		
        fade_timer += 1;
        inst_pres.visible = true;
        inst_pres.image_alpha = fade_timer / fade_duration;
		} 
	else {
        inst_pres.image_alpha = 1;
        inst_pres.visible = true;
		inst_dunk.visible =true;
        etat = 1;

    }
}

// ETAT 1 : animation manuelle de inst_dunk
if (etat == 1) {
    frame_timer += 1;

    if (frame_timer >= 10) {
        frame_timer = 0;
        inst_dunk.image_index += 1;

        if (inst_dunk.image_index >= 11) {
            inst_dunk.image_index = 11; // bloqué dernière frame
            etat = 2;
        }
    }
}

if (etat == 2) {
    inst_clingLoop.visible = true;
    timer_cling += 1 / room_speed; // compteur en secondes

    if (timer_cling >= 2) {
        etat = 3;
    }
}

if (etat == 3) {
    inst_loading .visible = true;
	timer_loading += 1 / room_speed;

    if (timer_loading >= 1) {
        etat = 4;
    }
}

if (etat == 4) {
	
    inst_loadingTroll .visible = true;
	inst_logo .visible = true;
	timer_loadingT += 1 / room_speed;

    if (timer_loadingT >= 1) {
        etat = 5;
    }
}