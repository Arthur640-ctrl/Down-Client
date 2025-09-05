extends Camera3D

@export var bob_amount: float = 0.1   # amplitude (mouvement haut/bas/gauche/droite)
@export var bob_speed: float = 3.0     # vitesse du balancement
@export var enable_bob: bool = true

var bob_timer: float = 0.0
var original_position: Vector3

func _ready():
	original_position = position

func _process(delta):
	var velocity = $"../..".velocity
	
	var speed = velocity.length()

	if enable_bob and speed > 0.1:
		bob_timer += delta * bob_speed
		# sinus pour haut/bas, cosinus pour gauche/droite
		var offset_y = sin(bob_timer) * bob_amount
		var offset_x = cos(bob_timer * 0.5) * bob_amount * 0.5
		position = original_position + Vector3(offset_x, offset_y, 0)
	else:
		# remet en place quand on s’arrête
		position = position.lerp(original_position, delta * 5)
