extends Node3D

@onready var player: CharacterBody3D = $".."
@onready var particules_left: GPUParticles3D = $mixamo_base/Node/Skeleton3D/ParticuleFootLeft/Particules_Left
@onready var particules_right: GPUParticles3D = $mixamo_base/Node/Skeleton3D/ParticuleFootRight/Particules_Right

func _process(delta: float) -> void:
	# Gestion des particules
	if player.velocity.length() > 0.1 and player.is_on_floor():
		particules_left.emitting = true
		particules_right.emitting = true
	else:
		particules_left.emitting = false
		particules_right.emitting = false
