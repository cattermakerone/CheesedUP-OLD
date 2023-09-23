function scr_player_barrelslide()
{
	image_speed = clamp(abs(movespeed) / 8, 0.35, 0.85);
	hsp = movespeed;
	if (abs(movespeed) < 14)
		movespeed = Approach(movespeed, xscale * 14, 0.1);
	if ((dashcloudtimer == 0 && abs(hsp) > 8) && grounded)
	{
		with (instance_create(x, y, obj_dashcloud2))
			image_xscale = other.xscale;
		dashcloudtimer = 15;
	}
	if (dashcloudtimer > 0)
		dashcloudtimer--;
	if (floor(image_index) == (image_number - 1))
	{
		if (sprite_index == spr_player_barrelslipnslide)
			sprite_index = spr_player_barrelroll;
	}
	if (!jumpstop && !key_jump2 && vsp < 0)
	{
		jumpstop = true;
		vsp /= 20;
	}
	if (input_buffer_jump > 0 && can_jump)
	{
		scr_fmod_soundeffect(jumpsnd, x, y);
		input_buffer_jump = 0;
		vsp = -8.5;
		jumpstop = false;
		create_particle(x, y, particle.highjumpcloud1, 0);
	}
	if ((!key_attack && !place_meeting(x, y + 1, obj_current)) && !scr_solid(x, y - 16) && !scr_solid(x, y - 32))
	{
		mask_index = spr_player_mask;
		if (!check_wall(x, y))
		{
			if (grounded)
				state = states.barrel;
			else
			{
				state = states.barreljump;
				sprite_index = spr_player_barrelfall;
			}
		}
	}
	with (instance_place(x + hsp, y, obj_destructibles))
		instance_destroy();
	if (check_wall(x + sign(hsp), y))
	{
		if (scr_slope())
		{
			with (instance_create(x, y, obj_speedlinesup))
				playerid = other.id;
			if (abs(movespeed) <= 5)
				vsp = -5;
			else if (abs(movespeed) >= 12)
				vsp = -12;
			else
				vsp = -abs(movespeed);
			state = states.barrelclimbwall;
			movespeed = 0;
			sound_play_3d("event:/sfx/barrel/slope", x, y);
			if (sprite_index != spr_player_barrelroll)
				sprite_index = spr_player_barrelroll;
		}
		else
		{
			GamepadSetVibration(0, 0.6, 0.6, 0.3);
			scr_fmod_soundeffect(barrelbumpsnd, x, y);
			xscale *= -1;
			movespeed = xscale * 8;
			instance_create(x + (xscale * 10), y + 10, obj_bumpeffect);
			if (place_meeting(x, y + 1, obj_current))
			{
				input_buffer_jump = 0;
				vsp = -8.5;
				jumpstop = true;
				create_particle(x, y, particle.highjumpcloud1, 0);
			}
		}
	}
	image_speed = abs(movespeed) / 10;
	image_speed = clamp(image_speed, 0.25, 0.85);
}