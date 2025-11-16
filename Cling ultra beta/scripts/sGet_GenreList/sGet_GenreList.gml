function Get_Genre_List_From_CSV() {
    var path = "Liste_Carte.csv";
    if (!file_exists(path)) {
        show_debug_message("Fichier introuvable : " + path);
        return [];
    }

    var file = file_text_open_read(path);
    var genre_set = ds_list_create();
    var result = [];

    // Lire ligne par ligne
    var is_first_line = true;
    while (!file_text_eof(file)) {
        var line = file_text_readln(file);
        line = string_trim(line);
        if (line == "") continue;

        if (is_first_line) {
            is_first_line = false;
            continue; // ignorer l’en-tête
        }

        // Nettoyage des crochets en début et fin
        if (string_starts_with(line, "[")) line = string_delete(line, 1, 1);
        if (string_ends_with(line, "]")) line = string_delete(line, string_length(line), 1);

        // Découpage des champs entre crochets
        var fields = string_split(line, "],[");
        if (array_length(fields) < 3) continue;

        var genre = string_trim(fields[2]); // champ Genre
        if (ds_list_find_index(genre_set, genre) == -1) {
            ds_list_add(genre_set, genre);
        }
    }

    file_text_close(file);

    ds_list_sort(genre_set, true);
    array_push(result, "Tous");

    for (var i = 0; i < ds_list_size(genre_set); i++) {
        array_push(result, genre_set[| i]);
    }

    ds_list_destroy(genre_set);
    return result;
}


