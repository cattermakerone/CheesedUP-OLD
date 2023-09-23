if (ds_list_find_index(global.saveroom, id) == -1)
{
	if REMIX
		scr_sound_multiple("event:/sfx/misc/breakblock", x, y);
	for (var i = 0; i < sprite_get_number(spr_pizzaballblock_debris); i++)
	{
		with (create_debris(REMIX ? random_range(bbox_left, bbox_right) : x, REMIX ? random_range(bbox_top, bbox_bottom) : y, spr_pizzaballblock_debris))
			image_index = i;
	}
	ds_list_add(global.saveroom, id);
}
