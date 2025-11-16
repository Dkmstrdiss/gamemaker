cards=ds_list_create();


#region function addcard
	addcard = function(card) 
	{
		ds_list_add(cards,card)	;
		updateDisplay();
		
	}
#endregion

#region function updateDisplay
updateDisplay = function() 
{
    var count = ds_list_size(cards);
    if (count == 0) return;

    // Espacement et éventail dynamiques
    var spacing = clamp(90 - count * 4, 30, 90);
    var ouverture = clamp(12 - count, 4, 12);

    var base_x = 960;
    var base_y = (isThisP1) ? 1060 : 20;
    var offset = -((count - 1) * spacing) / 2;

    for (var i = 0; i < count; i++) {
        var card = ds_list_find_value(cards, i);
        var index_centered = i - (count - 1) / 2;

        var angle_offset = index_centered * ouverture;
        var offset_y = 6 - sqr(index_centered) * 2;
        var scale = 0.2;

        // Positionnement carte
        card.x = base_x + offset + i * spacing;
        card.y = base_y + (isThisP1 ? -offset_y : offset_y);
        card.zone = "Hand";
        card.image_index = !isThisP1;
        card.image_angle = isThisP1 ? -angle_offset : angle_offset;
        card.image_xscale = scale;
        card.image_yscale = scale;

        // Assure que la carte a une profondeur paire
        card.depth = -1000 - i * 2;


        // Création et association de l’empreinte si absente
        if (!variable_instance_exists(card, "emprinte") || !instance_exists(card.emprinte)) {
            card.emprinte = instance_create_layer(0, 0, "Instances", oEmprinte);
            card.emprinte.visible = false;
            card.emprinte.owner = card;
        }

        // Mise à jour de l’empreinte
        var emp = card.emprinte;
        emp.x = card.x;
        emp.y = card.y;
        emp.image_angle = card.image_angle;
        emp.image_xscale = card.image_xscale;
        emp.image_yscale = card.image_yscale;
        emp.depth = card.depth - 1; // empreinte en dessous
    }
}
#endregion

