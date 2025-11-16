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
        deck         : [],                   // Tableau d'IDs de cartes (ordonné, top = dernier)
        hand         : [],                   // Cartes en main
        extra_deck   : [],                   // Pour fusions / cartes spéciales

        graveyard    : [],                   // Cimetière
        banished     : [],                   // Bannies

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
        has_played_creature    : false       // Règle : 1 créature max par tour
    };

    return p;
}
