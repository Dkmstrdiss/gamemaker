if (mouse_check_button_pressed(mb_left)) 
{
var clicked_on_card = false;
var clicked_on_ui = false;
var clicked_on_search = false ;
var clicked_on_Edit = false ;
var clicked_on_clone = false ;

	with (oCarte_MainDeck_Display) 
	{
	    if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) 
	
		{
							with (oPreview)
							{
					    instance_destroy();
							}

		
					var lolo = asset_get_index("Carte_Test");
					var spr_w = sprite_get_width(lolo);
					var spr_h = sprite_get_height(lolo);
					var scale = 0.45;

					var contener_w = sprite_get_width(oPreview_contener.sprite_index);
					var contener_h = sprite_get_height(oPreview_contener.sprite_index);

					global.selected_card = Carte_info.Carte_id;

					// Création du nouveau preview
					var inst = instance_create_layer(oPreview_contener.x, oPreview_contener.y, "bonus", oPreview);

					inst.sprite_index = sprite_index;
					inst.image_index = image_index;
					inst.image_xscale = scale;
					inst.image_yscale = scale;
					inst.Carte_info = Carte_info;

					// Centrage ajusté avec décalage
					inst.x = oPreview_contener.x - (contener_w / 2) + ((contener_w - (spr_w * scale)) / 2);
					inst.y = oPreview_contener.y - (contener_h / 2) + ((contener_h - (spr_h * scale)) / 2) - (contener_h * 0.05);



					        clicked_on_card = true;
		}
	}

	with (oCarte_Display) 
	{
	    if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) 
		{
	        global.selected_card = Carte_info.Carte_id;
		
							with (oPreview)
							{
					    instance_destroy();
							}
						var lolo = asset_get_index("Carte_Test");
						var spr_w = sprite_get_width(lolo);
						var spr_h = sprite_get_height(lolo);
						var scale = 0.45;

						var contener_w = sprite_get_width(oPreview_contener.sprite_index);
						var contener_h = sprite_get_height(oPreview_contener.sprite_index);
						// Création du nouveau preview
						var inst = instance_create_layer(oPreview_contener.x, oPreview_contener.y, "bonus", oPreview);

						inst.sprite_index = sprite_index;
						inst.image_index = image_index;
						inst.image_xscale = scale;
						inst.image_yscale = scale;

						// Centrage ajusté avec décalage
						inst.x = oPreview_contener.x - (contener_w / 2) + ((contener_w - (spr_w * scale)) / 2);
						inst.y = oPreview_contener.y - (contener_h / 2) + ((contener_h - (spr_h * scale)) / 2) - (contener_h * 0.05);

							clicked_on_card = true;
	    }
	}

	with (oSearchTyper) 
			{
		    if (point_in_rectangle(mouse_x, mouse_y, x - sprite_width * 0.5, y - sprite_height * 0.5, x + sprite_width * 0.5, y + sprite_height * 0.5)) 
					{
				        focused = true;
				        clicked_on_search = true;
				    }
		
		
			}
			
		with (oEditTyper) 
			{
		    if (point_in_rectangle(mouse_x, mouse_y, x - sprite_width * 0.5, y - sprite_height * 0.5, x + sprite_width * 0.5, y + sprite_height * 0.5) && oEditNameOff.image_index==1 ) 
					{
				        focused = true;
				        clicked_on_Edit = true;
				    }
		
		
			}		
					if (position_meeting(mouse_x, mouse_y, oLikeOff)) 
					{
					    clicked_on_ui = true;
						
					}

					if (!clicked_on_card && !clicked_on_ui) 
					{
					    global.selected_card = ""; // ou noone
						oLikeOff.image_index=0;
										// 🔥 Supprime le preview précédent
									with (oPreview)
									{
									    instance_destroy();
									}
					}
					
					if (!clicked_on_search)
					{
						oSearchTyper.focused = false;
						keyboard_string = "";
					}	
					
					if (!clicked_on_Edit)
					{
						oEditTyper.focused = false;
						keyboard_string = "";
					}
					
					
					
					
					
//		with (oEmptySlotOff) 
//		{
//		    is_selected = false;
//		}
//		with (instance_position(mouse_x, mouse_y, oEmptySlotOff)) 
//		{
//		    is_selected = true;
//		}
		
		

		
		
}