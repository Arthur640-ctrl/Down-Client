extends RayCast3D

func detect():
	if is_colliding():
		var collider = get_collider()
		var collision_point = get_collision_point()

		print("☑️ Touché :", collider)
		print("📍 Position de la collision :", collision_point)
		spawn_ball_at_position(collision_point)
		return collider	
	else:
		print("❌ Pas de collision détectée.")
	

const RED_BALL = preload("res://scenes/test_impact.tscn")

func spawn_ball_at_position(position: Vector3):
	# Crée une nouvelle instance de la boule
	var new_ball = RED_BALL.instantiate()
	
	# Ajoute la boule à la scène racine (scène principale)
	get_tree().root.add_child(new_ball)
	
	# Positionne la boule
	new_ball.global_position = position
