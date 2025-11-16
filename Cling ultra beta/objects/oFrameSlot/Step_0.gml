//var slots = oEmptySlotOff.slot_list;

function ZinZout ()
{
var is_hovering = point_in_rectangle(
    mouse_x, mouse_y,
    inst_Mngr.x - inst_Mngr.sprite_width / 2,
    inst_Mngr.y - inst_Mngr.sprite_height / 2,
    inst_Mngr.x + inst_Mngr.sprite_width / 2,
    inst_Mngr.y + inst_Mngr.sprite_height / 2
);

// ----- Définir la target scale -----
var target_scale = is_hovering ? 1.0 : 0.05;
var smooth2 = 0.4;

// ----- Interpolation du scale -----
image_xscale  = lerp(image_xscale,  target_scale, smooth2);
image_yscale  = lerp(image_yscale,  target_scale, smooth2);

// ----- Gestion du depth -----
if (is_hovering) {
    
    depth = oEmptySlotOff.depth - 1;
}
else if (image_xscale <= 0.06) { // une fois miniaturisé
    depth  = oEmptySlotOff.depth +1;
    
}
}


for (var i = 0; i < array_length(slot_pos_x); i++) 
{
    var sx = slot_pos_x[i];
    var sy = slot_pos_y[i];

    // Remplace par la taille de sprite utilisée pour tous les slots
    var spr_w = sprite_width; 
    var spr_h = sprite_height;

    if (point_in_rectangle(mouse_x, mouse_y,
                           sx - spr_w / 2,
                           sy - spr_h / 2,
                           sx + spr_w / 2,
                           sy + spr_h / 2)) 
    {
        last_hovered_slot_x = sx;
        last_hovered_slot_y = sy;
        last_hovered_slot_used = slot_used[i];
        break;
    }
}

        switch (global.slot_frame_mode) 
		{
		    case "libre":
		        image_index = 0;
		        visible = true;
				ZinZout();
		        x = lerp(x, last_hovered_slot_x, hover_speed);
		        y = lerp(y, last_hovered_slot_y, hover_speed);
		        break;
			case "selected":
				image_index = 0;
		        
			

            case "clone":
                //image_index = slot.is_used ? 2 : 1;
                break;

            case "delete":
               // image_index = slot.is_used ? 1 : 2;
			   			
						x = lerp(x, last_hovered_slot_x, hover_speed);
		    y = lerp(y, last_hovered_slot_y, hover_speed);
                break;

            case "save":

  
                break;
        }









