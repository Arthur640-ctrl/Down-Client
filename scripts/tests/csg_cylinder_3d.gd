extends CSGCylinder3D
@onready var ennemy: Node3D = $".."


func take_damage(damages):
	ennemy.take_damage(damages)
