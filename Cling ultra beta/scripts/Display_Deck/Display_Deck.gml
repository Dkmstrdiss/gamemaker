function update_visual_deck() {
    var p1 = (is_undefined(global.isThisP1) ? 1 : global.isThisP1);

    // Ensure visuals exist
    if (!ds_exists(player_a.deck_visual, ds_type_list)) return;
    if (!ds_exists(player_b.deck_visual, ds_type_list)) return;

    // Ensure deck anchors exist (odecka/odeckb)
    if (!instance_exists(odecka) || !instance_exists(odeckb)) return;
	
	
    if (p1 == 1) {
        var count_a = ds_list_size(player_a.deck_visual);
        for (var i = 0; i < count_a; i++) {
            var card_inst = player_a.deck_visual[| i];
            var offset = i / 3;
            card_inst.image_angle = odecka.image_angle;
            card_inst.image_index = 1;
            card_inst.x = odecka.x + offset;
            card_inst.y = odecka.y;
            card_inst.depth = -100000 + i;
			
        }

        var count_b = ds_list_size(player_b.deck_visual);
        for (var j = 0; j < count_b; j++) {
            var card_inst = player_b.deck_visual[| j];
            var offset = j / 3;
            card_inst.image_angle = odeckb.image_angle;
            card_inst.image_index = 1;
            card_inst.x = odeckb.x + offset;
            card_inst.y = odeckb.y;
            card_inst.depth = -100000 + j;
        }
    } else {
        // Swap perspectives: B uses odecka, A uses odeckb
        var count_b_as_a = ds_list_size(player_b.deck_visual);
        for (var i = 0; i < count_b_as_a; i++) {
            var card_inst = player_b.deck_visual[| i];
            var offset = i / 3;
            card_inst.image_angle = odecka.image_angle;
            card_inst.image_index = 1;
            card_inst.x = odecka.x + offset;
            card_inst.y = odecka.y;
            card_inst.depth = -100000 + i;
        }

        var count_a_as_b = ds_list_size(player_a.deck_visual);
        for (var j = 0; j < count_a_as_b; j++) {
            var card_inst = player_a.deck_visual[| j];
            var offset = j / 3;
            card_inst.image_angle = odeckb.image_angle;
            card_inst.image_index = 1;
            card_inst.x = odeckb.x + offset;
            card_inst.y = odeckb.y;
            card_inst.depth = -100000 + j;
        }
    }
}
