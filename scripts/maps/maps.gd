extends Node3D

@onready var cage: Node3D = $ascenteur/cage

func cage_change_pos(new_pos:Vector3):
	cage.position = new_pos

func _process(delta: float) -> void:
	
	if Globals.entities.has("cage"):
		cage_change_pos(Vector3(Globals.entities["cage"]["position"][0], Globals.entities["cage"]["position"][1], Globals.entities["cage"]["position"][2]))
