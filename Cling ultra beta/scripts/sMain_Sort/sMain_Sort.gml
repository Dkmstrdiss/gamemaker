function Sort_Deck_By_Genre(deck_in, deck_out) {
    // Copie du contenu
    ds_list_clear(deck_out);
    for (var i = 0; i < ds_list_size(deck_in); i++) {
        ds_list_add(deck_out, deck_in[| i]);
    }

    // Tri par Genre (ordre A → Z)
    var n = ds_list_size(deck_out);
    for (var i = 0; i < n - 1; i++) {
        for (var j = 0; j < n - i - 1; j++) {
            var a = deck_out[| j];
            var b = deck_out[| j + 1];

            if (string(a.Genre) > string(b.Genre)) {
                var temp = deck_out[| j];
                deck_out[| j] = deck_out[| j + 1];
                deck_out[| j + 1] = temp;
            }
        }
    }
}

