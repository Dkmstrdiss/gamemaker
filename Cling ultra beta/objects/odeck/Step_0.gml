

    var count = ds_list_size(player_a.deck);
    for (var i = 0; i < count; ++i) {
        var entry = player_a.deck[| i];
        var cid = -1;
        if (is_struct(entry) && variable_struct_exists(entry, "Carte_id")) {
            cid = entry.Carte_id;
        } else if (is_real(entry) || is_integer(entry) || is_string(entry)) {
            cid = round(real(entry));
        }
        ids_str += (i > 0 ? ", " : "") + string(cid);
    }
    show_message("playerA carte_id list: " + ids_str);


