fade_timer = 0;
fade_duration = 120;
frame_timer = 0;
timerframe = 0.5; // en secondes
timerenableframe = true;
etat = 0;
timer_cling = 0;
timer_loading= 0;
timer_loadingT= 0;

inst_pres = instance_find(oPres, 0);
inst_logo= instance_find(oLogo, 0);
inst_loadingTroll = instance_find(oLoadingTroll, 0);
inst_loading      = instance_find(oLoading, 0);
inst_dunk         = instance_find(oDunk, 0);
inst_clingLoop    = instance_find(oClingLoop, 0);

inst_dunk.image_index = 0;
inst_dunk.image_speed = 0;
inst_dunk.image_alpha = 1;

inst_pres.image_alpha = 0;




var inst_list = [inst_pres, inst_logo, inst_loadingTroll, inst_loading, inst_dunk, inst_clingLoop];
for (var i = 0; i < array_length(inst_list); i++) {
    var inst = inst_list[i];
    if (inst != noone) {
        inst.visible = false;

		frame_timer = 0;
    }
}
