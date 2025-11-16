// Création du deck et de la liste des instances de cartes
deck = ds_list_create();
cards = ds_list_create();

// Chargement du contenu du deck selon le camp
if (isThisP1) {
    script_execute(Userdeck, deck);
} else {
    script_execute(Oppsdeck, deck);
}

// Récupération de la position de l'objet deck
var deck_obj = (isThisP1) ? deck_user : deck_opps;
var deck_inst = instance_find(deck_obj, 0);

// Création des instances de cartes
for (var i = 0; i < ds_list_size(deck); i++) {
    var card_obj = ds_list_find_value(deck, i);
    var xx = deck_inst.x + i / 3;
    var yy = deck_inst.y;
    var scale = 0.2;

    var inst = instance_create_layer(xx, yy, "Instances", card_obj);
    inst.image_index = 1;
    inst.image_angle = image_angle;
    inst.image_xscale = scale;
    inst.image_yscale = scale;
    inst.depth = -i;
    inst.isThisP1 = isThisP1;

    ds_list_add(cards, inst);
}

// Attacher la liste et la fonction de pioche à l'instance deck
deck_inst.cards = cards;
deck_inst.pick = function () {
    if (ds_list_size(self.cards) == 0) return;

    var cardtopick = ds_list_find_value(self.cards, ds_list_size(self.cards) - 1);
    ds_list_delete(self.cards, ds_list_size(self.cards) - 1);

    var hand = (cardtopick.isThisP1) ? Hand_user : Hand_opps;
    hand.addcard(cardtopick);
};
