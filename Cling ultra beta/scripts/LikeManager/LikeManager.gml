function ReadLikeManager()
{
	    if (file_exists("liked_cards.txt")) {
        var f = file_text_open_read("liked_cards.txt");
        while (!file_text_eof(f)) {
            var carte_id = real(file_text_read_string(f));
            ds_list_add(global.liked_cards, carte_id);
            file_text_readln(f);
        }
        file_text_close(f);
    }

}

function WriteLikeManager(carte_id)
{
	var index = ds_list_find_index(global.liked_cards, carte_id);
	
    if (index == -1) {
        ds_list_add(global.liked_cards, carte_id); // Ajout
    } else {
        ds_list_delete(global.liked_cards, index); // Suppression
    }
	
	
}


function SaveLikedCards() {
    var f = file_text_open_write("liked_cards.txt");

    for (var i = 0; i < ds_list_size(global.liked_cards); i++) {
        file_text_write_string(f, string(global.liked_cards[| i]));
        file_text_writeln(f); // retour à la ligne après chaque ID
    }

    file_text_close(f);
}

function ResetLikedCards() {
    // Réinitialise la liste en mémoire
    if (ds_exists(global.liked_cards, ds_type_list)) {
        ds_list_clear(global.liked_cards);
    } else {
        global.liked_cards = ds_list_create();
    }

    // Écrase le fichier avec une version vide
    var f = file_text_open_write("liked_cards.txt");
    file_text_close(f);
}