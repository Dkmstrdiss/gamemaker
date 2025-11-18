/// Affichage du cercle de phases (GUI)
/// - 5 parts égales
/// - Rotation synchronisée avec la phase courante

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var cx    = gui_w - 120;
var cy    = 120;
var r_out = 72;
var r_in  = 36;
var steps = 8;
var count = phase_wheel_segments;
var base  = -90 + phase_wheel_rotation;

if (count <= 0) exit;

var angle_step = phase_wheel_angle;

// Fond circulaire
var bg_col = make_color_rgb(18, 22, 28);
draw_set_alpha(0.8);
draw_set_color(bg_col);
draw_circle(cx, cy, r_out, true);
draw_set_alpha(1);

for (var i = 0; i < count; ++i) {
    var start_ang = base + (i * angle_step);
    var end_ang   = start_ang + angle_step;
    var slice_col = (i == current_phase_index) ? c_orange : make_color_hsv(200, 0.05, 0.82);

    draw_set_color(slice_col);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(cx, cy);
    for (var s = 0; s <= steps; ++s) {
        var t  = s / steps;
        var a  = lerp(start_ang, end_ang, t);
        var vx = cx + lengthdir_x(r_out, a);
        var vy = cy + lengthdir_y(r_out, a);
        draw_vertex(vx, vy);
    }
    draw_primitive_end();

    // Séparateurs
    draw_set_color(make_color_rgb(12, 14, 18));
    var lx = cx + lengthdir_x(r_out, start_ang);
    var ly = cy + lengthdir_y(r_out, start_ang);
    draw_line_width(cx, cy, lx, ly, 2);
}

// Cercle intérieur pour ajourer le centre
var inner_col = make_color_rgb(10, 12, 16);
draw_set_color(inner_col);
draw_circle(cx, cy, r_in, true);

// Libellé de phase courante
if (current_phase_index < array_length(phase_labels)) {
    var label = phase_labels[current_phase_index];
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(cx, cy, label);
}
