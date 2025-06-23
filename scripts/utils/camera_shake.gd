extends Camera3D

var shake_strength: float = 0.0
var shake_decay: float = 2.0
var original_transform: Transform3D

func _ready():
	original_transform = transform

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		var random_offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shake_strength * 0.1

		transform.origin = original_transform.origin + random_offset
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
	else:
		transform.origin = original_transform.origin

func shake(strength: float):
	shake_strength = strength
