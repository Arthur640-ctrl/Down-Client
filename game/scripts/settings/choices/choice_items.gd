extends TextureRect

@export var change_button: Button

@export var choice_panels: Array[Panel]
@export var choice_name: Array[String]
@export var choice_sys_name: Array[String]

@export var setting_category: String
@export var setting_params_name: String

@export var label_setting_name: Label
@export var label_setting_value: Label

var actual_setting = 0
var nmbr_setting = 0

func _ready() -> void:
	change_button.pressed.connect(_on_change_button_pressed)
	nmbr_setting = choice_panels.size() - 1
	
	
	for panel in choice_panels:
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color8(93, 76, 121)
		panel.add_theme_stylebox_override("panel", stylebox)
	
	if Globals.settings.has(setting_category):
		if Globals.settings[setting_category].has(setting_params_name.to_lower()):
			var actual_value = Globals.settings[setting_category][setting_params_name.to_lower()]
			if actual_value in choice_sys_name:
				var actual_value_index = choice_sys_name.find(actual_value)
				var stylebox = StyleBoxFlat.new()
				stylebox.bg_color = Color8(204, 204, 204)
				choice_panels[actual_value_index].add_theme_stylebox_override("panel", stylebox)
				label_setting_value.text = choice_name[actual_value_index]
				actual_setting = actual_value_index
				

func _on_change_button_pressed() -> void:
	if actual_setting == nmbr_setting:
		actual_setting = 0
	else:
		actual_setting += 1
	
	change_color()
	actualize()

func change_color():
	for panel in choice_panels:
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color8(93, 76, 121)
		panel.add_theme_stylebox_override("panel", stylebox)
		
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color8(204, 204, 204)
	choice_panels[actual_setting].add_theme_stylebox_override("panel", stylebox)
	label_setting_value.text = choice_name[actual_setting]

func actualize():
	Globals.settings[setting_category][setting_params_name] = choice_sys_name[actual_setting]
