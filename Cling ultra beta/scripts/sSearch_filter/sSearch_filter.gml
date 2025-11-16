/// @func SearchFilter(Listo, Listo_filtered)
/// Listo : array OU ds_list de templates carte (Carte_id, Name, Genre...)
/// Listo_filtered : ds_list de sortie
function SearchFilter(Listo, Listo_filtered)
{
    ds_list_clear(Listo_filtered);

    var is_arr       = is_array(Listo);
    var size         = is_arr ? array_length(Listo) : ds_list_size(Listo);
    var search_text  = string_lower(global.text_input);
    var filter_genre = global.selected_genre;
    var filter_fav   = global.only_favorites;

    for (var i = 0; i < size; i++)
    {
        // Récupération de la carte (template)
        var card = is_arr ? Listo[i] : Listo[| i];
        if (!is_struct(card)) continue;

        // Champs de base
        var card_id    = variable_struct_exists(card, "Carte_id") ? card.Carte_id : -1;
        var card_genre = variable_struct_exists(card, "Genre")    ? card.Genre    : "";
        var card_name  = variable_struct_exists(card, "Name")     ? card.Name     : "";

        // --- Filtre Genre ---
        if (filter_genre != "" && filter_genre != "Tous") {
            if (card_genre != filter_genre) continue;
        }

        // --- Filtre Favoris ---
        if (filter_fav) {
            if (ds_list_find_index(global.liked_cards, card_id) == -1) continue;
        }

        // --- Filtre texte sur le nom ---
        if (string_length(search_text) > 0) {
            var name_low = string_lower(card_name);
            if (string_pos(search_text, name_low) == 0) continue;
        }

        // Si tous les filtres passent, on garde la carte
        ds_list_add(Listo_filtered, card);
    }
}
