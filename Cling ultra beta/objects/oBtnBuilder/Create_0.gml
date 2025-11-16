SearchPage1 = 1;
SearchPage2 = 1;
global.selected_genre = "Tous";
global.sorted = 0;
global.only_favorites = false;

global.liked_cards = ds_list_create();
ReadLikeManager();

// Création / chargement de la base de cartes
// NE PAS faire : global.card_db = ds_list_create();
Lecteur_carte(); // doit remplir global.card_db (array de templates)

// Filtrage
global.Listo_filtered = ds_list_create();
SearchFilter(global.card_db, global.Listo_filtered);

// Tri
global.Listo_filt_sorted = ds_list_create();
SearchSorter(global.Listo_filtered, global.Listo_filt_sorted);

// Affichage
Refresh_Search_Page(global.Listo_filt_sorted);

global.main_deck = ds_list_create();
global.sorted_main_deck = ds_list_create();




