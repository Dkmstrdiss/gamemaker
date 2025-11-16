hovered = false;
hover_target_x = x;
hover_target_y = y;
hover_speed = 0.2;
last_hovered_slot_x = x;
last_hovered_slot_y = y;
last_hovered_slot_used = noone;
visible = false;
global.slot_frame_mode = "libre";


var slots = global.slot_list;
slot_pos_x = [];
slot_pos_y = [];
slot_used = [];

for (var i = 0; i < array_length(slots); i++) {
    var slot = slots[i];
    array_push(slot_pos_x, slot.x);
    array_push(slot_pos_y, slot.y);
    array_push(slot_used, slot.is_used);
}
