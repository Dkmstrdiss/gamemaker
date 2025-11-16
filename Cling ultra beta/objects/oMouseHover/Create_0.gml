function update_hovered_card() {
    var best_emp = noone;
    var best_depth = 999999;

    // Parcours de toutes les empreintes
    with (oEmprinte) {
        if (instance_exists(owner) && owner.zone == "Hand" && position_meeting(mouse_x, mouse_y, id)) {
            if (depth < best_depth) {
                best_depth = depth;
                best_emp = id;
            }
        }
    }

    // Mise à jour de tous les owners
    with (oEmprinte) {
        if (instance_exists(owner) && owner.zone == "Hand") {
			if (id == best_emp) {
			    owner.y_hovered = y - 40;
			    owner.is_hovered = true;
			    owner.depth = -99999; // juste au-dessus de son empreinte
			} else {
			    owner.y_hovered = y;
			    owner.is_hovered = false;
			    owner.depth = depth + 1; // reste juste au-dessus de l’emprinte
			}
            owner.y = lerp(owner.y, owner.y_hovered, 0.3);
        }
    }
}
