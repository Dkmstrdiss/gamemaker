var smooth = 0.2; // vitesse de déplacement fluide
var threshold = 100;

if (abs(mouse_y - y_solo) < threshold) {
    inst_backbtn.y  = lerp(inst_backbtn.y,  y_solo,  smooth);
    inst_framebtn.y = lerp(inst_framebtn.y, y_solo,  smooth);
}
else if (abs(mouse_y - y_versus) < threshold) {
    inst_backbtn.y  = lerp(inst_backbtn.y,  y_versus,  smooth);
    inst_framebtn.y = lerp(inst_framebtn.y, y_versus,  smooth);
}
else if (abs(mouse_y - y_builderbtn) < threshold) {
    inst_backbtn.y  = lerp(inst_backbtn.y,  y_builderbtn,  smooth);
    inst_framebtn.y = lerp(inst_framebtn.y, y_builderbtn,  smooth);
}
else if (abs(mouse_y - y_exit) < threshold) {
    inst_backbtn.y  = lerp(inst_backbtn.y,  y_exit,  smooth);
    inst_framebtn.y = lerp(inst_framebtn.y, y_exit,  smooth);
}

var is_hovering = point_in_rectangle(
    mouse_x, mouse_y,
    inst_backgbtn.x,
    inst_backgbtn.y,
    inst_backgbtn.x + inst_backgbtn.sprite_width,
    inst_backgbtn.y + inst_backgbtn.sprite_height
);

// ----- Définir la target scale -----
var target_scale = is_hovering ? 1.0 : 0.05;
var smooth2 = 0.4;

// ----- Interpolation du scale -----
inst_backbtn.image_xscale  = lerp(inst_backbtn.image_xscale,  target_scale, smooth2);
inst_backbtn.image_yscale  = lerp(inst_backbtn.image_yscale,  target_scale, smooth2);
inst_framebtn.image_xscale = lerp(inst_framebtn.image_xscale, target_scale, smooth2);
inst_framebtn.image_yscale = lerp(inst_framebtn.image_yscale, target_scale, smooth2);

// ----- Gestion du depth -----
if (is_hovering) {
    inst_backbtn.depth  = 2;
    inst_framebtn.depth = 1;
}
else if (inst_backbtn.image_xscale <= 0.06) { // une fois miniaturisé
    inst_backbtn.depth  = 4;
    inst_framebtn.depth = 4;
}