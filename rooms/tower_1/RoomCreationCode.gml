global.roommessage = lang_get_value("room_tower1");
if (global.panic == false)
	global.gameframe_caption_text = "Oldest part of the Pizza Tower";
global.door_sprite = spr_door;
global.door_index = 0;
if (global.panic)
{
	with (obj_door)
		instance_create(x + 50, y + 96, obj_rubble);
	with (obj_bossdoor)
		instance_create(x + 50, y + 96, obj_rubble);
	instance_destroy(obj_door);
	instance_destroy(obj_bossdoor);
}
scr_random_granny();
