extends Node3D

# ===== ASSETS =====
@onready var muzzle_flash: Node3D = $MuzzleFlash
@onready var raycast: RayCast3D = $"../../../../../../../camera_mount/Camera3D/RayCast3D"
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var reload_particules: GPUParticles3D = $ReloadSmoke/GPUParticles3D
# =================

var gun_type = "assault_rifle"
var gun_name = "Premier Fusil"
var ammo_type = "mini"
var max_magazine = 30
var current_magazine = 30
var damage = 10
var cadence = 0.05
var scope = 20
var reload_time = 5

var can_shoot = true

func shoot():
	if can_shoot:
		if current_magazine == 0 or current_magazine < 0:
			print("Can SHoot") 
		else:
			animations.play("shoot")
			var collider = raycast.detect()
			muzzle_flash.add_muzzle_flash()
			can_shoot = false
			await get_tree().create_timer(cadence).timeout
			can_shoot = true
			
			if collider and collider.has_method("take_damage"):
				collider.take_damage(10)
			
			current_magazine -= 1
			print("Fire ! Current magazine : ", current_magazine)
			
func reload():
	if current_magazine < max_magazine:
		reload_particules.emitting = true
		await get_tree().create_timer(reload_time).timeout
		reload_particules.emitting = false
		current_magazine = max_magazine
	else:
		print("Magazine Full")
	
