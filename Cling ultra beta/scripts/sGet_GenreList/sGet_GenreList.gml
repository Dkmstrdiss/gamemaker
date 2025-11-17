function Get_Genre_List_From_CSV() {
    if (!is_array(global.card_db)) {
        Lecteur_carte();
    }

    if (!is_array(global.card_db)) {
        show_debug_message("[Get_Genre_List] Impossible de charger global.card_db");
        return [];
    }

    var genre_set = ds_list_create();
    var result = [];

    for (var i = 0; i < array_length(global.card_db); i++) {
        var template = global.card_db[i];
        if (!is_struct(template)) continue;

        var genre = string_trim(string(template.Genre));
        if (genre == "") continue;

        if (ds_list_find_index(genre_set, genre) == -1) {
            ds_list_add(genre_set, genre);
        }
    }

    ds_list_sort(genre_set, true);
    array_push(result, "Tous");

    for (var j = 0; j < ds_list_size(genre_set); j++) {
        array_push(result, genre_set[| j]);
    }

    ds_list_destroy(genre_set);
    return result;
}


