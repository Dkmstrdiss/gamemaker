




var mx = device_mouse_x(0);
var my = device_mouse_y(0);
	
	var scales = 0.8;
	
	var drag_offset_x = (x - mx)* scales;
	var drag_offset_y = (y - my)* scales;
	
	var clone_x = mx + drag_offset_x;
	var clone_y = my + drag_offset_y;
	
	if (!instance_exists(oCarte_Clone))
	{
	        var clone = instance_create_layer(clone_x, clone_y, "bonus", oCarte_Clone);
		clone.visible=false;
        clone.sprite_index = sprite_index;
        clone.image_xscale = scales * image_xscale;
        clone.image_yscale = scales * image_yscale;
        clone.Carte_info = Carte_info;
		// Transfert des offsets
		clone.drag_offset_x = drag_offset_x * scales;
		clone.drag_offset_y = drag_offset_y * scales;
		clone.grabbed_in_search=false;

		
	}