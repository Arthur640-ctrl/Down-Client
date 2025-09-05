extends Node3D

# ====================
@onready var player: CharacterBody3D = $"../../../../../.."
@onready var weapon_pivot: Node3D = $"."
# ====================
@onready var gun_test: Node3D = $Gun
@onready var stalker_47_silencieux: Node3D = $"Stalker-47 Silencieux"
# ====================
var guns_position = {
	"test": {
		"aiming": {
			"rotation": Vector3(-24, 89.3, 112.5),
			"position": Vector3(12.982, -22.154, -4.646)
		},
		"idle": {
			"rotation": Vector3(-38.5, 41.3, 133.4),
			"position": Vector3(21.108, -10.787, 3.827)
		}
	},
	"Stalker-47 Silencieux": {
		"aiming": {
			"rotation": Vector3(52.7, 95.5, 99.3),
			"position": Vector3(9.898, -6.065, -3.224)
		},
		"idle": {
			"rotation": Vector3(22, 76.8, 110.7),
			"position": Vector3(9.964, 2.13, 4.811)
		}
	},
}
var guns = {}
# =============
func _ready():
	guns = {
		"test": gun_test,
		"Stalker-47 Silencieux": stalker_47_silencieux
	}

func get_weapon_position(state, weapon):
	for gun in guns_position:
		if weapon == gun:
			return guns_position[gun][state]["position"]
				
func get_weapon_rotation(state, weapon):
	for gun in guns_position:
		if weapon == gun:
			return guns_position[gun][state]["rotation"]
					

func _process(delta: float) -> void:
	weapon_pivot.position = Vector3(0, 0, 0)
	weapon_pivot.rotation = Vector3(0, 0, 0)
	
	if player.current_hand != null and player.current_hand.has("item"):
		if player.is_aiming:
			if player.current_hand["item"] == "test":
				var aiming_pos = get_weapon_position("aiming", "test")
				var aiming_rot = get_weapon_rotation("aiming", "test")
				gun_test.position = aiming_pos
				gun_test.rotation = aiming_rot
			if player.current_hand["item"] == "Stalker-47 Silencieux":
				var aiming_pos = get_weapon_position("aiming", "Stalker-47 Silencieux")
				var aiming_rot = get_weapon_rotation("aiming", "Stalker-47 Silencieux")
				stalker_47_silencieux.position = aiming_pos
				stalker_47_silencieux.rotation_degrees  = aiming_rot
		else:
			if player.current_hand["item"] == "test":
				var aiming_pos = get_weapon_position("idle", "test")
				var aiming_rot = get_weapon_rotation("idle", "test")
				gun_test.position = aiming_pos
				gun_test.rotation = aiming_rot
			elif player.current_hand["item"] == "Stalker-47 Silencieux":
				var aiming_pos = get_weapon_position("idle", "Stalker-47 Silencieux")
				var aiming_rot = get_weapon_rotation("idle", "Stalker-47 Silencieux")
				stalker_47_silencieux.position = aiming_pos
				stalker_47_silencieux.rotation_degrees  = aiming_rot
				
