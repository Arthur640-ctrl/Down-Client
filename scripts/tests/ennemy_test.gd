extends Node3D

# Propriétés de l'ennemi
var health = 100

# Fonction appelée par le RayCast
func take_damage(amount: int):
	health -= amount
	print("L'ennemi a perdu des PV ! Santé actuelle: ", health)
	
	# Si la santé atteint 0, l'ennemi meurt
	if health <= 0:
		die()

func die():
	print("L'ennemi est mort!")
	queue_free()  # Supprime l'objet de la scène (si nécessaire)
