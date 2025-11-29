 /// scr_player_create.gml
/// Crée et initialise la structure d'un joueur Cling.
/// @param _player_id  (PlayerId.PlayerA / PlayerId.PlayerB)
///
/// @return struct joueur

function Player_Create(_player_id) {

    var p = {

        // ------------------------------------------------
        // IDENTITÉ
        // ------------------------------------------------
        id           : _player_id,           // PlayerId.PlayerA ou PlayerId.PlayerB
        life         : global.PLAYER_START_LIFE,

        // ------------------------------------------------
        // RESSOURCES DE CARTES
        // ------------------------------------------------
        deck         : ds_list_create(),
		deck_visual  : ds_list_create(),// Pile de pioche logique (top = fin de liste)
        hand         : ds_list_create(),
		hand_visual  : ds_list_create(),// Main du joueur (ordre conservé)
        extra_deck   : ds_list_create(),     // Pour fusions / cartes spéciales

        graveyard    : ds_list_create(),     // Cimetière
        banished     : ds_list_create(),     // Bannies

        // ------------------------------------------------
        // REFS VISUELLES
        // ------------------------------------------------
        deck_visual  : noone,                // Instance odeck associée
        hand_visual  : noone,                // Instance oHand associée

        // ------------------------------------------------
        // PLATEAU LOGIQUE (SLOTS)
        // ------------------------------------------------
        // On stocke l'ID d'instance de carte ou -1 s’il n’y a rien.
        board_attack : array_create(global.BOARD_ATTACK_SLOTS, -1),
        board_defense: array_create(global.BOARD_DEFENSE_SLOTS, -1),
        board_action : array_create(global.BOARD_ACTION_SLOTS, -1),

        // ------------------------------------------------
        // SOUFFLE FINAL
        // ------------------------------------------------
        final_breath_active    : false,      // Le Souffle Final est-il lancé pour ce joueur ?
        final_breath_turns_left: 0,          // Compteur des 5 tours restants
        final_breath_phase     : FinalBreathPhase.None,

        // ------------------------------------------------
        // UTILITAIRES DE TOUR
        // ------------------------------------------------
        has_played_creature    : false,      // Règle : 1 créature max par tour
        mulligan_used          : false,      // Indique si le joueur a déjà utilisé son mulligan
        mulligan_available     : true,       // Fenêtre de mulligan ouverte après la main de départ
        starting_hand_size     : 0           // Taille de la main de départ réellement piochée
    };

    return p;
}
