with (instance_create(x, y, obj_medievalprojectile))
	vsp = -18;
instance_create(x, y + 43, obj_bangeffect);
sound_play_3d("event:/sfx/enemies/kill", x, y);
with (instance_create(x, y, obj_sausageman_dead))
	sprite_index = spr_forknight_dead;
