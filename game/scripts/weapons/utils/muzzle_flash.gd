extends Node3D

@export var light : OmniLight3D
@export var emitter : GPUParticles3D

func _ready() -> void:
	light.visible = false
	emitter.emitting = false

func add_muzzle_flash(flash_time: float = 0.05):
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false
	
