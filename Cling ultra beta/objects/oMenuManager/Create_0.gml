

// Récupération directe des instances
inst_backbtn    = instance_find(oBackbtn, 0);
inst_backgbtn   = instance_find(oBackGBtn, 0);
inst_builderbtn = instance_find(oBuilderbtn, 0);
inst_exit       = instance_find(oExit, 0);
inst_framebtn   = instance_find(oFramebtn, 0);
inst_solo       = instance_find(oSolo, 0);
inst_versus     = instance_find(oVersus, 0);



// Visibilité initiale


// Depth ordonné : plus grand = plus profond
inst_backgbtn.depth     = 3;
inst_backbtn.depth      = 2;
inst_framebtn.depth     = 1;
inst_solo.depth         = 0;
inst_versus.depth       = 0;
inst_builderbtn.depth   = 0;
inst_exit.depth         = 0;

var scale = 0.05;
//inst_backbtn.image_xscale = scale;
//inst_backbtn.image_yscale = scale;

//inst_framebtn.image_xscale =scale;
//inst_framebtn.image_yscale =scale;

y_solo       = inst_solo.y;
y_versus     = inst_versus.y;
y_builderbtn = inst_builderbtn.y;
y_exit       = inst_exit.y;

var menu_btn_list = [
    inst_backbtn,
    inst_backgbtn,
    inst_builderbtn,
    inst_exit,
    inst_framebtn,
    inst_solo,
    inst_versus
];

for (var i = 0; i < array_length(menu_btn_list); i++) {
    var inst = menu_btn_list[i];
    inst.visible = true;
    inst.image_alpha = 1; // si tu veux aussi les rendre invisibles graphiquement
}


