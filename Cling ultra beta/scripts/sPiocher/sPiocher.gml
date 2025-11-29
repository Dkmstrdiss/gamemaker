function piocher(_player, nbr) {
    if (!is_struct(_player)) return [];
    if (!ds_exists(_player.deck, ds_type_list)) return [];
    if (!ds_exists(_player.hand, ds_type_list)) return [];

    // Visual lists: create if missing
    if (!ds_exists(_player.deck_visual, ds_type_list)) _player.deck_visual = ds_list_create();
    if (!ds_exists(_player.hand_visual, ds_type_list)) _player.hand_visual = ds_list_create();

    var want = max(1, floor(real(nbr)));
    var drawn = [];              // logical cards moved
    var moved_visuals = [];      // optional: visuals moved (instances)

    repeat (want) {
        var deck_sz = ds_list_size(_player.deck);
        if (deck_sz <= 0) break;

        var idx = 0;
        // If using “top = end of list”, use:
        // idx = deck_sz - 1;

        // Move logical card
        var card = _player.deck[| idx];
        ds_list_delete(_player.deck, idx);
        ds_list_add(_player.hand, card);
        array_push(drawn, card);

        // Move corresponding visual instance (aligned by index)
        var vis_sz = ds_list_size(_player.deck_visual);
        if (vis_sz > idx) {
            var vis = _player.deck_visual[| idx];
            ds_list_delete(_player.deck_visual, idx);
            ds_list_add(_player.hand_visual, vis);
            array_push(moved_visuals, vis);
        }
    }

    // Optionally return visuals as well; if you only need cards, keep `drawn`.
    // return { cards: drawn, visuals: moved_visuals };
    return drawn;
}