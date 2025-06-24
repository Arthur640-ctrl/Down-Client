extends Node3D

# ============= RÉFÉRENCES NODES
@onready var ik_marker: Marker3D = $ik_marker
@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $".."

# ============= PARAMÈTRES DÉCLARÉS (au cas où tu ne passes pas par Globals)
@export var sens_horizontal = 0.05
@export var sens_vertical = 0.05

# ============= INTERNE
var yaw = 0
var pitch = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if player.mvt_block:
		return
		
	if event is InputEventMouseMotion:
		if Globals.PREDICTION:
			# Rotation horizontale
			player.rotate_y(deg_to_rad(-event.relative.x * Globals.sens_x))

			# Inversion Axe Y				
			var invert_multiplier := -1 if Globals.invert_y else 1
			var new_x_rot = rotation_degrees.x - event.relative.y * Globals.sens_y * invert_multiplier
			new_x_rot = clamp(new_x_rot, -90, 90)
			rotation_degrees.x = new_x_rot

		# Appliquer la rotation synchronisée
		if Globals.multiplayer:
			rotation_degrees = Globals.new_infos["camera_rotation"]

		# Stocker l'event pour les autres systèmes
		Globals.EVENT_MOUSE = {
			"relative": [event.relative.x, event.relative.y],
			"position": [event.position.x, event.position.y],
			"sens_horizontal": Globals.sens_x,
			"sens_vertical": Globals.sens_y
		}
		
func _process(delta: float) -> void:
	camera.current = Globals.PLAYER_CAM_CURRENT
	
	if not player.mvt_block:
		if Input.is_action_pressed("aiming"):
			$"../visuals/mixamo_base/Node/Skeleton3D/AimingIK".start()
		else:
			await get_tree().create_timer(0.2).timeout
			$"../visuals/mixamo_base/Node/Skeleton3D/AimingIK".stop()
