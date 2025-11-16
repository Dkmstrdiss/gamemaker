// Gestion du timer de pioche automatique
if (timerpick > 0 && timerenablepick) {
    timerpick -= 1 / room_speed;
}
else if (timerenablepick) {
    var deck_user_inst = instance_find(deck_user, 0);
    var deck_opps_inst = instance_find(deck_opps, 0);

    deck_user_inst.pick();
    deck_opps_inst.pick();

    if (ds_list_size(Hand_user.cards) < 5) {
        timerpick = 0.5;
    } else {
        timerenablepick = false;
    }
}
