extends Node

var keyboard_icon = {
}

var keyboard_root_path = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/"

func get_keyboard_icon(keycode):
	if keycode >= 65 and keycode <= 90:
		var caracter = keycode_to_char(keycode)
		return keyboard_root_path + "keyboard_" + caracter.to_lower() + ".png"
	
	elif keycode >= 48 and keycode <= 57:
		var digit = keycode_to_digit(keycode)
		return keyboard_root_path + "keyboard_" + digit.to_lower() + ".png"
		
	elif keycode >= 4194332 and keycode <= 4194343 :
		var function = keycode_to_function_key_name(keycode)
		return keyboard_root_path + "keyboard_" + function + ".png"
		
	elif keycode == 4194305:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_escape.png"
	
	elif keycode == 4194306:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_tab.png"
		
	elif keycode == 4194308:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_backspace_icon_alternative.png"
		
	elif keycode == 4194310:
		return
		
	elif keycode == 4194311:
		# INSERT key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_insert.png"

	elif keycode == 4194312:
		# DELETE key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_delete.png"

	elif keycode == 4194313:
		# PAUSE key
		return 

	elif keycode == 4194314:
		# PRINT SCREEN key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_printscreen.png"

	elif keycode == 4194315:
		# SYSTEM REQUEST key
		return 

	elif keycode == 4194316:
		# CLEAR key
		return

	elif keycode == 4194317:
		# HOME key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_home.png"

	elif keycode == 4194318:
		# END key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_end.png"

	elif keycode == 4194319:
		# LEFT ARROW key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_arrows_left.png"

	elif keycode == 4194320:
		# UP ARROW key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_arrows_up.png"

	elif keycode == 4194321:
		# RIGHT ARROW key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_arrows_right.png"

	elif keycode == 4194322:
		# DOWN ARROW key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_arrows_down.png"

	elif keycode == 4194323:
		# PAGE UP key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_page_up.png"

	elif keycode == 4194324:
		# PAGE DOWN key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_page_down.png"

	elif keycode == 4194325:
		# SHIFT key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_shift_icon.png"

	elif keycode == 4194326:
		# CTRL (Control) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_ctrl.png"

	elif keycode == 4194327:
		# META (Windows/Command) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_win.png"

	elif keycode == 4194328:
		# ALT key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_alt.png"

	elif keycode == 4194329:
		# CAPS LOCK key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_capslock_icon.png"

	elif keycode == 4194330:
		# NUM LOCK key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_numlock.png"

	elif keycode == 4194331:
		# SCROLL LOCK key
		return
		
	elif keycode == 32:
		# SPACE key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_space_icon.png"

	elif keycode == 33:
		# EXCLAMATION MARK (!)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_exclamation.png"

	elif keycode == 36:
		# DOLLAR SIGN ($)
		return

	elif keycode == 37:
		# PERCENT SIGN (%)
		return

	elif keycode == 38:
		# AMPERSAND (&)
		return

	elif keycode == 39:
		# APOSTROPHE (')
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_2.png"

	elif keycode == 40:
		# LEFT PARENTHESIS (()
		return

	elif keycode == 41:
		# RIGHT PARENTHESIS ())
		return

	elif keycode == 42:
		# ASTERISK (*)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_asterisk.png"

	elif keycode == 43:
		# PLUS SIGN (+)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_plus.png"

	elif keycode == 44:
		# COMMA (,)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_comma.png"

	elif keycode == 45:
		# MINUS SIGN (-)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_minus.png"

	elif keycode == 46:
		# PERIOD / DOT (.)
		return

	elif keycode == 47:
		# SLASH (/)
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_slash_forward.png"

	elif keycode == 58:
		# COLON (:) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_colon.png"

	elif keycode == 59:
		# SEMICOLON (;) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_semicolon.png"

	elif keycode == 60:
		# LESS-THAN SIGN (<) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_bracket_less.png"

	elif keycode == 61:
		# EQUAL SIGN (=) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_equals.png"

	elif keycode == 62:
		# GREATER-THAN SIGN (>) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_bracket_greater.png"

	elif keycode == 63:
		# QUESTION MARK (?) key
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_question.png"

	elif keycode == 64:
		# AT SIGN (@) key
		return
		
	elif keycode == 4194309:
		# Enter
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Vector/keyboard_enter.svg"
		
	elif keycode == 4194310:
		# KP Enter
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Vector/keyboard_enter.svg"

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
	if button_index == 1:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_left.png"
	elif button_index == 2:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_right.png"
	elif button_index == 3:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll.png"
	elif button_index == 4:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll_up.png"
	elif button_index == 5:
		return "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll_down.png"

func get_controler_icon(button_index):
	if Globals.controler == "xbox":
		# A/B/X/Y
		if button_index == 0:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_a.png"
		elif button_index == 1:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_b.png"
		elif button_index == 2:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_x.png"
		elif button_index == 3:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_y.png"
		
		# Select / Center / Start
		elif button_index == 4:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_back_icon.png"
		elif button_index == 5:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/controller_xbox360.png"
		elif button_index == 6:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_button_start.png"
			
		# Joystick Click Left / Right
		elif button_index == 7:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_l_press.png"
		elif button_index == 8:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_r_press.png"
			
		# L1 / R1
		elif button_index == 9:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_lb.png"
		elif button_index == 10:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_rb.png"
			
		# Up / Down / Left / Right
		elif button_index == 11:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_dpad_up.png"
		elif button_index == 12:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_dpad_down.png"
		elif button_index == 13:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_dpad_left.png"
		elif button_index == 14:
			return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_dpad_right.png"

func get_motion_icon(axis, axis_value):
	# JLeft
	# Left/Right
	if axis == 0 and axis_value < 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_l_left.png"
	elif axis == 0 and axis_value > 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_l_right.png"
	# Up/Down
	if axis == 1 and axis_value < 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_l_up.png"
	elif axis == 1 and axis_value > 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_l_down.png"
	
	# JRight
	# Left/Right
	if axis == 2 and axis_value < 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_r_left.png"
	elif axis == 2 and axis_value > 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_r_right.png"
	# Up/Down
	if axis == 3 and axis_value < 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_r_up.png"
	elif axis == 3 and axis_value > 0:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_stick_r_down.png"
		
	# Right
	elif axis == 4:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_lt.png"
	elif axis == 5:
		return "res://models/kenney_input-prompts_1.4/Xbox Series/Default/xbox_rt.png"
