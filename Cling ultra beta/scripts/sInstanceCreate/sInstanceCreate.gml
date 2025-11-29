

function InstCreate(_deck) {
    _layer_name = "Instances";


    var result = ds_list_create();

    if (!ds_exists(_deck, ds_type_list)) {
        show_message("[sInstenceCreate] _deck is not a ds_list");
        return result;
    }


    var count = ds_list_size(_deck);
    for (var i = 0; i < count; ++i) {
        var entry = _deck[| i];
		
        // Déterminer l'id de la carte (Carte_id)
        var cid = undefined;
        if (is_struct(entry) && variable_struct_exists(entry, "Carte_id")) {
            cid = entry.Carte_id;
        } else if (is_real(entry) || is_string(entry) || is_integer(entry)) {
            cid = round(real(entry));
        }

        // Créer l'instance
        var inst = instance_create_layer(0, 0, "Instances", oCarte);

        // Assigner les données utiles
        inst.card_info = entry;


        // Choisir le sprite 
       
         var spr = asset_get_index("Carte_" + string(cid));
			

      

        inst.sprite_index = spr;
        inst.image_speed = 0;
        inst.image_index = 0;
		inst.image_xscale = 0.20;
		inst.image_yscale = 0.20;
        // Optionnel : positionner au centre pour le preload, sinon 0,0
        inst.x = room_width / 2;
        inst.y = room_height / 2;
		inst.zone = Zone.Init;
        ds_list_add(result, inst);
    }

    return result;
}

