extends TextureRect


@export var slider:Slider

@export var setting_category: String
@export var setting_params_name: String

@export var label_setting_name: Label
@export var label_setting_value: Label

var actual_setting = 0
var nmbr_setting = 0

func _ready() -> void:
	
	slider.connect("value_changed", Callable(self, "_on_slider_value_changed"))
	
	if Globals.settings.has(setting_category):
		if Globals.settings[setting_category].has(setting_params_name.to_lower()):
			var actual_value = Globals.settings[setting_category][setting_params_name.to_lower()]
			slider.value = int(actual_value)
			label_setting_value.text = str(actual_value) + "%"


func _on_slider_value_changed(value):
	slider.value = value
	label_setting_value.text = str(value) + "%"
	
func actualize():
	Globals.settings[setting_category][setting_params_name] = slider.value
	
func _process(delta: float) -> void:
	actualize()
	
