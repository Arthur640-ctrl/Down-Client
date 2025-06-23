extends Control

var actual_setting_section = "main"
@onready var settings_category: Label = $ScrollContainer/items/settings_category

func _ready() -> void:
	settings_category.text = tr("settings_section_main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
