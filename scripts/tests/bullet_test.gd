extends RigidBody3D

@export var speed: float = 80.0
@export var lifetime: float = 3.0
@export var damage: int = 10

func _ready():
	# Supprime la balle après X secondes
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _integrate_forces(state):
	# Déplace la balle constamment en avant
	linear_velocity = -transform.basis.z * speed  # z avant

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
