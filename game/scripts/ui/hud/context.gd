extends CenterContainer

@onready var raycast: RayCast3D = $"../../camera_mount/camera/RayCast3D"

@onready var label: Label = $HBoxContainer/Label
@onready var texture_rect: TextureRect = $UI_GAME/Context/HBoxContainer/TextureRect
@onready var pointer_context: Label = $"../pointer_context"

var controler = null

func _ready() -> void:
	controler = Globals.controler

func _process(delta: float) -> void:
	visible = false
	pointer_context.text = "None"
	
	var collider = raycast.detect_raycast(3.5, false)
	
	if collider:
		if collider.is_in_group("interactable") and collider.has_method("get_infos"):
			var infos = collider.get_infos()
			visible = true
			pointer_context.text = infos["display_name"]
			label.text = infos["context_text"]
			
