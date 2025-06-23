extends StaticBody3D

@onready var inventory: Control = $UI_GAME/inventory
@export var light: OmniLight3D
@export var animations: AnimationPlayer

var rarity = null

func set_rarity():
	match rarity:
		"primitif":
			light.light_color = Color(0.627, 0.627, 0.627)    # #a0a0a0
		"traditionnelle":
			light.light_color = Color(0, 0.411, 0.016)        # #006904
		"specialisé":
			light.light_color = Color(0.031, 0.329, 0.561)    # #08548f
		"haut-gamme":
			light.light_color = Color(0.612, 0.153, 0.690)    # #9c27b0
		"elite":
			light.light_color = Color(1, 0.596, 0)             # #ff9800
		"legendaire":
			light.light_color = Color(1, 0.922, 0.231)         # #ffeb3b
		"experimentale":
			light.light_color = Color(0.588, 0.2, 0.2)         # #963333

func _ready() -> void:
	rarity = $"../..".get_meta("rarity")
	set_rarity()
	
func pickup():
	animations.play("ramassé")
	queue_free()
	
func get_infos():
	return {"item": "Stalker-47", "rarity": rarity, "number": null}

func get_item_position():
	return $"../..".position
