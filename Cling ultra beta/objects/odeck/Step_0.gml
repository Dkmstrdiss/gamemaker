
function Visual_Deck(deck_visual)
{
var count = ds_list_size(player_a.deck_visual);

for (var i = 0; i < count; i++)
{
    var offset = count / 3;

    with (oCarte)
    {
        image_angle = odeck.image_angle;
        image_index = 1;
        x = odeck.x + offset;
        y = odeck.y;

        depth = -100000 + i;
    }
}


}