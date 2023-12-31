if live_call() return live_result;

// animation / background
sprite_index = -1;
sound_play("event:/sfx/pto/diagopen");

charshift = [0, 0, 0];
anim_con = 0;
anim_t = 0;
outback = animcurve_get_channel(curve_menu, "outback");
incubic = animcurve_get_channel(curve_menu, "incubic");
jumpcurve = animcurve_get_channel(curve_jump, "curve1");

surface = -1;
clip_surface = -1;
bg_surf = -1;
bg_pos = 0;

image_speed = 0.35;
depth = -500;

// control
init = false;
postdraw = -1;
draw = -1;
select = -1;
arrowbuffer = -1;

scr_init_input();
open_menu();

sel = {
	pal: 1,
	char: 0
};
characters = [
	["P", spr_player_idle, spr_peppalette, 1], // character, idle, palette sprite, main color
	//["N", spr_playerN_idle, spr_noisepalette, 1]
];

// set in user event 0
palettes = [];
unlockables = [];

add_palette = function(palette, entry, texture = noone, name = "PALETTE", description = "loypoll please add details")
{
	// check if the palette was unlocked
	if array_get_index(unlockables, entry) != -1
	{
		ini_open_from_string(obj_savesystem.ini_str_options);
		if !ini_read_real("Palettes", entry, false)
		{
			ini_close();
			exit;
		}
		ini_close();
	}
	
	array_push(palettes, {
		palette: palette,
		entry: entry,
		texture: texture,
		name: name,
		description: description
	});
}

// automatically select character
if instance_exists(obj_player1)
{
	for(var i = 0; i < array_length(characters); i++)
	{
		if obj_player1.character == characters[i][0]
			sel.char = i;
	}
	
	noisetype = obj_player1.noisetype
}

// DO THE FUNNY
event_user(0);

// functions
select = function()
{
	var same = false;
	with obj_player1
	{
		var prevchar = character, prevpal = paletteselect, prevtex = global.palettetexture, prevnoise = noisetype;
		
		// apply it
		character = other.characters[other.sel.char][0];
		scr_characterspr();
		paletteselect = other.palettes[other.sel.pal].palette;
		global.palettetexture = other.palettes[other.sel.pal].texture;
		noisetype = other.noisetype;
		
		// if nothing changed, don't save
		if character == prevchar && paletteselect == prevpal && noisetype == prevnoise && global.palettetexture == prevtex
			same = true;
		
		if !same
		{
			// setup animation
			xscale = 1;
			create_particle(x, y, particle.genericpoofeffect);
			visible = false;
			
			// save
			ini_open_from_string(obj_savesystem.ini_str);
			ini_write_string("Game", "character", character);
			ini_write_real("Game", "palette", paletteselect);
			ini_write_string("Game", "palettetexture", other.palettes[other.sel.pal].entry);
			obj_savesystem.ini_str = ini_close();
			gamesave_async_save();
		}
	}
	anim_con = 2;
	sound_play_centered(sfx_collecttoppin);
}
postdraw = function(curve)
{
	if anim_con == 2 && !obj_player1.visible
	{
		var curve2 = animcurve_channel_evaluate(jumpcurve, 1 - anim_t);
		
		var pal = palettes[sel.pal];
		var charx = 960 / 2 + charshift[0] * 100, chary = 540 / 2 - 16 + charshift[1] * 100, scale = clamp(lerp(1, 2, curve), 1, 2);
		
		charx = lerp(charx, obj_player1.x - camera_get_view_x(view_camera[0]), 1 - anim_t);
		chary = lerp(chary, obj_player1.y - camera_get_view_y(view_camera[0]), curve2);
		
		shader_set(global.Pal_Shader);
		if pal.texture != noone
			pattern_set(global.Base_Pattern_Color, characters[sel.char][1], -1, scale, scale, pal.texture);
		
		pal_swap_set(characters[sel.char][2], pal.palette, false);
		draw_sprite_ext(characters[sel.char][1], -1, charx, chary, scale, scale, 0, c_white, 1);
		pattern_reset();
	}
}
draw = function(curve)
{
	var curve2 = anim_t;
	
	var pal = palettes[sel.pal];
	if anim_con != 0
	{
		curve = 1; // actual animated curve
		curve2 = 1; // the timer
	}
	
	if anim_con != 2 or obj_player1.visible
	{
		// character
		var charx = 960 / 2 + charshift[0] * 100, chary = 540 / 2 - 16 + charshift[1] * 100;
		
		shader_set(global.Pal_Shader);
		if pal.texture != noone
			pattern_set(global.Base_Pattern_Color, characters[sel.char][1], -1, 2, 2, pal.texture);	
		pal_swap_set(characters[sel.char][2], pal.palette, false);
		if characters[sel.char][0] == "N"
		{
			var nsprite = spr_playerN_idle;
			
			if noisetype == 0
				nsprite = spr_playerN_idle;
		
			else if noisetype == 1
				nsprite = spr_playerN_pogofall;
				
			draw_sprite_ext(nsprite, -1, charx, chary, 2, 2, 0, c_white, curve * charshift[2]);
		}
		else
			draw_sprite_ext(characters[sel.char][1], -1, charx, chary, 2, 2, 0, c_white, curve * charshift[2]);
		reset_shader_fix();
		pattern_reset();
		
		// arrows
		if sel.pal > 0
		{
			var xx = 960 / 2 - 120 - sin(current_time / 200) * 4, yy = 540 / 2 + 16;
			if charshift[0] < 0
				xx += charshift[0] * 100;
			
			if palettes[sel.pal - 1].texture != noone
			{
				scr_palette_texture(spr_palettearrow, 0, xx, yy, 1, 1, 90, c_white, 1, true, palettes[sel.pal - 1].texture);
				draw_sprite_ext(spr_palettearrow, 1, xx, yy, 1, 1, 90, c_white, 1);
			}
			else
				draw_sprite_ext(spr_palettearrow, 0, xx, yy, 1, 1, 90, pal_swap_get_pal_color(characters[sel.char][2], palettes[sel.pal - 1].palette, 1), 1);
		}
		if sel.pal < array_length(palettes) - 1
		{
			var xx = 960 / 2 + 120 + sin(current_time / 200) * 4, yy = 540 / 2 + 16;
			if charshift[0] > 0
				xx += charshift[0] * 100;
			
			if palettes[sel.pal + 1].texture != noone
			{
				scr_palette_texture(spr_palettearrow, 0, xx, yy, 1, 1, 270, c_white, 1, true, palettes[sel.pal + 1].texture);
				draw_sprite_ext(spr_palettearrow, 1, xx, yy, 1, 1, 270, c_white, 1);
			}
			else
				draw_sprite_ext(spr_palettearrow, 0, xx, yy, 1, 1, 270, pal_swap_get_pal_color(characters[sel.char][2], palettes[sel.pal + 1].palette, 1), 1);
		}
	}
	
	// text
	draw_set_font(lang_get_font("bigfont"));
	draw_set_align(fa_left);
	
	var name = string_upper(pal.name);
	var xx = 960 / 2 - string_width(name) / 2;
	
	for(var i = 1; i <= string_length(name); i++)
	{
		var char = string_char_at(name, i);
		
		var yy = 400;
		if curve2 != 1 // letters jump up
			yy = lerp(540, 400, min(animcurve_channel_evaluate(outback, curve2 + ((i % 3) * 0.075))));
		
		draw_text(xx + random_range(-1, 1), yy + random_range(-1, 1), char);
		xx += string_width(char);
	}
	
	draw_set_align(fa_center);
	draw_set_alpha(curve);
	draw_set_font(global.font_small);
	draw_text(960 / 2, 450, pal.description);
	draw_set_alpha(1);
}
