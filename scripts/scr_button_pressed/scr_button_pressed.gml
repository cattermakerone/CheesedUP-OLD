function scr_button_pressed(gamepad)
{
	if (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(global.key_jump) or keyboard_check_pressed(global.key_jumpN))
		return -1;
	else if (gamepad_is_connected(gamepad))
	{
		if (gamepad_button_check(gamepad, gp_face1) or gamepad_button_check(gamepad, gp_start))
			return gamepad;
	}
	return -2;
}