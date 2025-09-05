extends Node

var keyboard_icon = {}

var keyboard_root_path = "res://models/game/kenney_input-prompts_1.4/Keyboard & Mouse/Default/"

func get_keyboard_icon(keycode):
	if keycode >= 65 and keycode <= 90:
		var caracter = keycode_to_char(keycode)
		return keyboard_root_path + "keyboard_" + caracter.to_lower() + ".png"

	elif keycode >= 48 and keycode <= 57:
		var digit = keycode_to_digit(keycode)
		return keyboard_root_path + "keyboard_" + digit.to_lower() + ".png"

	elif keycode >= 4194332 and keycode <= 4194343:
		var function = keycode_to_function_key_name(keycode)
		return keyboard_root_path + "keyboard_" + function + ".png"

	elif keycode == 4194305:
		return keyboard_root_path + "keyboard_escape.png"

	elif keycode == 4194306:
		return keyboard_root_path + "keyboard_tab.png"

	elif keycode == 4194308:
		return keyboard_root_path + "keyboard_backspace_icon_alternative.png"

	elif keycode == 4194311:
		return keyboard_root_path + "keyboard_insert.png"

	elif keycode == 4194312:
		return keyboard_root_path + "keyboard_delete.png"

	elif keycode == 4194314:
		return keyboard_root_path + "keyboard_printscreen.png"

	elif keycode == 4194317:
		return keyboard_root_path + "keyboard_home.png"

	elif keycode == 4194318:
		return keyboard_root_path + "keyboard_end.png"

	elif keycode == 4194319:
		return keyboard_root_path + "keyboard_arrows_left.png"

	elif keycode == 4194320:
		return keyboard_root_path + "keyboard_arrows_up.png"

	elif keycode == 4194321:
		return keyboard_root_path + "keyboard_arrows_right.png"

	elif keycode == 4194322:
		return keyboard_root_path + "keyboard_arrows_down.png"

	elif keycode == 4194323:
		return keyboard_root_path + "keyboard_page_up.png"

	elif keycode == 4194324:
		return keyboard_root_path + "keyboard_page_down.png"

	elif keycode == 4194325:
		return keyboard_root_path + "keyboard_shift_icon.png"

	elif keycode == 4194326:
		return keyboard_root_path + "keyboard_ctrl.png"

	elif keycode == 4194327:
		return keyboard_root_path + "keyboard_win.png"

	elif keycode == 4194328:
		return keyboard_root_path + "keyboard_alt.png"

	elif keycode == 4194329:
		return keyboard_root_path + "keyboard_capslock_icon.png"

	elif keycode == 32:
		return keyboard_root_path + "keyboard_space_icon.png"

	elif keycode == 33:
		return keyboard_root_path + "keyboard_exclamation.png"

	elif keycode == 39:
		return keyboard_root_path + "keyboard_2.png"

	elif keycode == 42:
		return keyboard_root_path + "keyboard_asterisk.png"

	elif keycode == 43:
		return keyboard_root_path + "keyboard_plus.png"

	elif keycode == 44:
		return keyboard_root_path + "keyboard_comma.png"

	elif keycode == 45:
		return keyboard_root_path + "keyboard_minus.png"

	elif keycode == 47:
		return keyboard_root_path + "keyboard_slash_forward.png"

	elif keycode == 58:
		return keyboard_root_path + "keyboard_colon.png"

	elif keycode == 59:
		return keyboard_root_path + "keyboard_semicolon.png"

	elif keycode == 60:
		return keyboard_root_path + "keyboard_bracket_less.png"

	elif keycode == 61:
		return keyboard_root_path + "keyboard_equals.png"

	elif keycode == 62:
		return keyboard_root_path + "keyboard_bracket_greater.png"

	elif keycode == 63:
		return keyboard_root_path + "keyboard_question.png"

	elif keycode == 4194309 or keycode == 4194310:
		return "res://models/game/kenney_input-prompts_1.4/Keyboard & Mouse/Vector/keyboard_enter.svg"

func keycode_to_digit(keycode: int) -> String:
	if keycode >= 48 and keycode <= 57:
		return char(keycode)
	return ""

func keycode_to_function_key_name(keycode: int) -> String:
	if keycode >= 4194332 and keycode <= 4194343:
		var number := keycode - 4194332 + 1
		return "f" + str(number)
	return ""

func keycode_to_char(keycode: int) -> String:
	if keycode >= 65 and keycode <= 90:
		return char(keycode)
	return ""

func get_mouse_icon(button_index):
	var path = "res://models/game/kenney_input-prompts_1.4/Keyboard & Mouse/Default/"
	if button_index == 1:
		return path + "mouse_left.png"
	elif button_index == 2:
		return path + "mouse_right.png"
	elif button_index == 3:
		return path + "mouse_scroll.png"
	elif button_index == 4:
		return path + "mouse_scroll_up.png"
	elif button_index == 5:
		return path + "mouse_scroll_down.png"

func get_controler_icon(button_index):
	var base = "res://models/game/kenney_input-prompts_1.4/Xbox Series/Default/"
	if Globals.controler == "xbox":
		match button_index:
			0: return base + "xbox_button_a.png"
			1: return base + "xbox_button_b.png"
			2: return base + "xbox_button_x.png"
			3: return base + "xbox_button_y.png"
			4: return base + "xbox_button_back_icon.png"
			5: return base + "controller_xbox360.png"
			6: return base + "xbox_button_start.png"
			7: return base + "xbox_stick_l_press.png"
			8: return base + "xbox_stick_r_press.png"
			9: return base + "xbox_lb.png"
			10: return base + "xbox_rb.png"
			11: return base + "xbox_dpad_up.png"
			12: return base + "xbox_dpad_down.png"
			13: return base + "xbox_dpad_left.png"
			14: return base + "xbox_dpad_right.png"

func get_motion_icon(axis, axis_value):
	var base = "res://models/game/kenney_input-prompts_1.4/Xbox Series/Default/"
	if axis == 0:
		if axis_value < 0:
			return base + "xbox_stick_l_left.png"
		elif axis_value > 0:
			return base + "xbox_stick_l_right.png"
	elif axis == 1:
		if axis_value < 0:
			return base + "xbox_stick_l_up.png"
		elif axis_value > 0:
			return base + "xbox_stick_l_down.png"
	elif axis == 2:
		if axis_value < 0:
			return base + "xbox_stick_r_left.png"
		elif axis_value > 0:
			return base + "xbox_stick_r_right.png"
	elif axis == 3:
		if axis_value < 0:
			return base + "xbox_stick_r_up.png"
		elif axis_value > 0:
			return base + "xbox_stick_r_down.png"
	elif axis == 4:
		return base + "xbox_lt.png"
	elif axis == 5:
		return base + "xbox_rt.png"
