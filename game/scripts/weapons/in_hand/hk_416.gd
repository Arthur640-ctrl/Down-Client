extends Node3D

@onready var audio_tir: AudioStreamPlayer3D = $shoot
@export var light : OmniLight3D
@export var emitter : GPUParticles3D
@export var aiming_camera : Camera3D
@onready var shoot_empty: AudioStreamPlayer3D = $shoot_empty

var gun_type = "assault_rifle"
var ammo_type = "fusil"
var max_magazine = 30
var current_magazine = 30
var damage = 10
var cadence = 0.05
var scope = 20
var reload_time = 5
var player = null
var can_shoot = true
func _ready():
	player = get_node("/root/word/player")

	if player:
		print("Player trouvé !")
	else:
		print("Player non trouvé, vérifie le chemin du nœud.")

func shoot():
	if can_shoot:
		player.current_magazine = current_magazine
		if player.current_magazine == 0 or player.current_magazine < 0:
			print("Impossible, plus de munitiions")
			shoot_empty.play()
		else:
			audio_tir.play()
			add_muzzle_flash()
			player.current_magazine -= 1
			current_magazine -= 1
			can_shoot = false
			await get_tree().create_timer(cadence).timeout
			can_shoot = true

func reload():
	if current_magazine == max_magazine:
		print("Munition déjà pleines")
	else:
		var munitions_disponible_reload = max_magazine - current_magazine
		can_shoot = false
		await get_tree().create_timer(reload_time).timeout
		can_shoot = true
		if player.ammo_inventory["rifle"] >= munitions_disponible_reload:
			player.ammo_inventory["rifle"] -= munitions_disponible_reload
			current_magazine = max_magazine
		else:
			current_magazine += player.ammo_inventory["rifle"]
			player.ammo_inventory["rifle"] = 0

func load_weapon():
	player.current_magazine = current_magazine

func add_muzzle_flash(flash_time: float = 0.05):
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false
