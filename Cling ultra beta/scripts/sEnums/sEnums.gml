/// scr_cling_enums.gml
/// Centralisation des enums et constantes globales pour Cling TCG.
/// À inclure/charger très tôt dans le projet (avant toute logique de game).

//------------------------------------------------------
// CONFIG GÉNÉRALE DU PLATEAU
//------------------------------------------------------
/// Nombre maximum de slots par ligne (attaque/défense/action)
global.BOARD_ATTACK_SLOTS  = 3;
global.BOARD_DEFENSE_SLOTS = 3;
global.BOARD_ACTION_SLOTS  = 3;

/// Points de vie de départ
global.PLAYER_START_LIFE = 15; // Variante rapide possible à 5

//------------------------------------------------------
// ENUM : TYPE DE CARTE
//------------------------------------------------------
/// Type logique des cartes : détermine leur comportement de base.
/// Utilisé dans la base de données de cartes et les effets.
enum CardType {
    Creature,    // Possède ATT / DEF / PRD et participe aux combats
    Action,      // Effets ponctuels ou continus, joue surtout depuis la colonne Action
    Fusion,      // Créature spéciale invoquée sous conditions (ex : "Ultime femme au foyer")
    Legendary,   // Flag logique : nécessite sacrifice, unique sur le terrain
    Token        // Créature générée par effet (ex : "Danzo")
}

//------------------------------------------------------
// ENUM : ZONE / EMPLACEMENT DES CARTES
//------------------------------------------------------
/// Représente la position actuelle d'une carte dans la partie.
/// Sert autant à la logique qu'au lien avec l'affichage.
enum Zone {
	
	Init,
    // Zones génériques
    Deck,        // Pile de pioche
    Hand,        // Main du joueur

    // Ligne offensive (3 slots)
    AttackLine_0,
    AttackLine_1,
    AttackLine_2,

    // Ligne défensive (3 slots)
    DefenseLine_0,
    DefenseLine_1,
    DefenseLine_2,

    // Colonne des cartes Action (jusqu'à 3 simultanées)
    ActionColumn_0,
    ActionColumn_1,
    ActionColumn_2,

    // Zones de sortie
    Graveyard,   // Cimetière (cartes détruites / résolues)
    Banished,    // Bannies / exilées
    ExtraDeck,   // Deck spécial pour fusions / cartes avancées

    // État temporaire
    Unplaced     // Carte en transition / animation (ex : vient d'être piochée, en choix)
}

//------------------------------------------------------
// ENUM : PHASES DU TOUR
//------------------------------------------------------
/// Machine d'état principale d'un tour de joueur.
/// Correspond 1:1 avec la structure de tour décrite dans les règles.
enum Phase {
    Draw,        // Pioche de carte(s)
    Main,        // Pose de 1 créature max + cartes Action
    Attack,      // Déclaration des attaques depuis la ligne offensive
    Defense,     // Choix des bloqueurs/intercepteurs sur la ligne défensive
    Resolution,  // Résolution des combats (ATT / DEF / PRD, Essoufflement)
    Action,      // Fenêtre d'utilisation de certaines cartes Action post-combat
    End          // Fin de tour (reset temporaire, gestion PRD, etc.)
}

//------------------------------------------------------
// ENUM : PHASES SPÉCIALES DU "SOUFFLE FINAL" (OPTIONNEL)
//------------------------------------------------------
/// Si tu veux intégrer le Souffle Final dans la même machine d'état,
/// tu peux soit étendre `Phase`, soit gérer ça avec un autre enum.
/// Voici une version séparée si tu préfères cloisonner.
enum FinalBreathPhase {
    None,            // Pas de Souffle Final actif
    Init,            // Mélange du cimetière, récupération de 5 cartes, reconstitution deck
    TurnSequence,    // Les 5 derniers tours spéciaux
    Resolution       // Choix dés/pièces + calcul ATT/PRD globale
}

//------------------------------------------------------
// ENUM : JOUEUR (OPTIONNEL MAIS UTILE TOUT DE SUITE)
//------------------------------------------------------
/// Permet de référencer clairement le propriétaire d'une carte ou d'un slot.
enum PlayerId {
    PlayerA,   // Joueur en bas de l'écran (par défaut local)
    PlayerB    // Joueur en haut de l'écran (adversaire)
}

//------------------------------------------------------
// NOTES D’UTILISATION (RAPIDE)
//------------------------------------------------------
/// Exemple d'utilisation dans une carte :
/// var c = {};
/// c.type = CardType.Creature;
/// c.zone = Zone.Hand;
/// c.owner = PlayerId.PlayerA;
///
/// Exemple de test de phase :
/// if (global.current_phase == Phase.Attack) {
///     // Autoriser la déclaration des attaques
/// }
///
/// Exemple de test de zone :
/// if (card.zone == Zone.Graveyard) {
///     // Effets liés au cimetière
/// }
