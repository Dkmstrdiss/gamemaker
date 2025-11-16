if (ds_list_find_index(global.liked_cards, global.selected_card) != -1) {
    inst_Like.image_index = 1;
} else {
    inst_Like.image_index = 0;
}