extends TextureRect

@onready var input_selection: Control = $"../../../../../Input_selection"

@export var keyboard_key_icon: TextureRect
@export var keyboard_edit_btn: TextureButton

@export var controler_key_icon: TextureRect
@export var controller_edit_btn: TextureButton

@export var action_name: String

var key_pressed = null
var waiting_for_any_input := false
var waiting_for_input = ""

var icon_path: String

var action_exist = ["forward", "backward", "left", "right", "run", "crouched", "aiming", "fire", "reload", "inventory_up", "inventory_down", "interact", "inventory"]

func _unhandled_input(event):
	if waiting_for_any_input:
		
		if event is InputEventKey and waiting_for_input == "keyboard":
			print("Key pressed:", event.keycode, " (", OS.get_keycode_string(event.keycode), ")")
			var texture_icon = UtilsInputIcon.get_keyboard_icon(event.keycode)
			if texture_icon:
				keyboard_key_icon.texture = load(texture_icon)
			input_selection.visible = false
			waiting_for_any_input = false
			actualize(event)

		elif event is InputEventMouseButton and waiting_for_input == "keyboard":
			print("Mouse button:", event.button_index)
			var texture_icon = UtilsInputIcon.get_mouse_icon(event.button_index)
			if texture_icon:
				keyboard_key_icon.texture = load(texture_icon)
			input_selection.visible = false
			waiting_for_any_input = false
			actualize(event)

		elif event is InputEventJoypadButton and waiting_for_input == "controller":
			print("Joy button:", event.button_index)
			var texture_icon = UtilsInputIcon.get_controler_icon(event.button_index)
			if texture_icon:
				controler_key_icon.texture = load(texture_icon)
			input_selection.visible = false
			waiting_for_any_input = false
			actualize(event)

		elif event is InputEventJoypadMotion and waiting_for_input == "controller":
			print("Joy axis:", event.axis, "Value:", event.axis_value)
			var texture_icon = UtilsInputIcon.get_motion_icon(event.axis, event.axis_value)
			if texture_icon:
				controler_key_icon.texture = load(texture_icon)
			input_selection.visible = false
			waiting_for_any_input = false
			actualize(event)

func _ready():
	keyboard_edit_btn.pressed.connect(_on_keyboard_edit_pressed)
	controller_edit_btn.pressed.connect(_on_controller_edit_pressed)

func _on_keyboard_edit_pressed():
	input_selection.visible = true
	waiting_for_any_input = true
	waiting_for_input = "keyboard"

func _on_controller_edit_pressed():
	input_selection.visible = true
	waiting_for_any_input = true
	waiting_for_input = "controller"

func actualize(event):
	if event is InputEventKey or event is InputEventMouseButton:
		Globals.settings["inputs"]["action_" + action_name]["keyboard"] = event
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		Globals.settings["inputs"]["action_" + action_name]["controller"] = event
		
	#print("| Keyboard : ", Globals.settings["inputs"]["action_" + action_name]["keyboard"])
	#print("| Controller : ", Globals.settings["inputs"]["action_" + action_name]["controller"])
