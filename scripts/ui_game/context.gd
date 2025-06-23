extends CenterContainer

@export var context: Label
@export var icon: TextureRect

func _ready() -> void:
	reset()
	get_icon_with_key("fire")
	
func reset():
	icon.texture = null
	context.text = ""

func update_icon(action_name: String):
	var path = get_icon_with_key(action_name)
	icon.texture = load(path)
	
func update_context(my_text: String):
	context.text = my_text

func mouse_button_to_string(button_index: int) -> String:
	match button_index:
		MOUSE_BUTTON_LEFT: return "Left Click"
		MOUSE_BUTTON_RIGHT: return "Right Click"
		MOUSE_BUTTON_MIDDLE: return "Middle Click"
		MOUSE_BUTTON_WHEEL_UP: return "Scroll Up"
		MOUSE_BUTTON_WHEEL_DOWN: return "Scroll Down"
		MOUSE_BUTTON_WHEEL_LEFT: return "Scroll Left"
		MOUSE_BUTTON_WHEEL_RIGHT: return "Scroll Right"
		_: return "Mouse Button " + str(button_index)

func get_icon_with_key(action_name: String):
	var events = InputMap.action_get_events(action_name)
	var inputs := []
	for event in events:
		if event is InputEventKey:
			var key_string := OS.get_keycode_string(event.physical_keycode)
			inputs.append(key_string)
		elif event is InputEventMouseButton:
			inputs.append(mouse_button_to_string(event.button_index))
	# print("Inputs reconnus : ", inputs[0])
	
	var icon = null
	var base_path = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/"
	
	if inputs[0] == "Left Click":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_left.png"
	elif inputs[0] == "Right Click":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_right.png"
	elif inputs[0] == "Middle Click":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll.png"
	elif inputs[0] == "Scroll Up":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll_up.png"
	elif inputs[0] == "Scroll Down":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll_down.png"
	elif inputs[0] == "Scroll Down":
		icon = "res://models/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_scroll_down.png"
	else:
		icon = base_path + "keyboard_" + inputs[0].to_lower() + ".png"
	
	return icon
