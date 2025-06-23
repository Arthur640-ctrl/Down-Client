extends TextureRect

var opened = false
@onready var player: CharacterBody3D = $"../.."

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if opened == true:
			player.mvt_block = false
			opened = false
		else:
			player.mvt_block = true
			opened = true
	
	visible = opened
	
	if opened == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
