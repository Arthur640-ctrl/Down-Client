extends Node3D

@onready var entities_node: Node3D = $"../entities"

var actual_entities = []
var actual_entities_nodes = {}  # id (int) -> Node

var entities_models = {
	200001: preload("res://game/entities/scenes/200001.tscn"),
	100001 : preload("res://game/entities/scenes/100001.tscn"),
	500001: preload("res://game/entities/scenes/500001.tscn"),
	999999: preload("res://game/entities/scenes/zone.tscn")
}

func entity_exists(ent_id: int) -> bool:
	for e in actual_entities:
		if int(e["id"]) == ent_id:
			return true
	return false

var i = 0

func _process(delta: float) -> void:
	var serverEntities = Globals.entities
	
	if i == 50:
		i = 0
		#print(server_entities)
	else:
		i += 1
	
	var server_actual_entities = []
	var client_actual_entities = []
	
	for entitie in serverEntities:
		
		var ent_id = int(entitie["id"])
		var ent_model = int(entitie["model"])
		var ent_pos = Vector3(entitie["position"][0], entitie["position"][1], entitie["position"][2])
		var ent_rot = Vector3(entitie["rotation"][0], entitie["rotation"][1], entitie["rotation"][2])
		var ent_state = entitie["state"]

		server_actual_entities.append(ent_id)

		if actual_entities_nodes.has(ent_id):
			var node = actual_entities_nodes[ent_id]
			node.global_position = ent_pos
			node.rotation_degrees = ent_rot
			
			actualize_states(ent_model, ent_state, node)
		else:
			var new_entitie = entities_models[ent_model].instantiate()
			new_entitie.global_position = ent_pos
			new_entitie.rotation_degrees = ent_rot
			entities_node.add_child(new_entitie)
	
			actual_entities_nodes[ent_id] = new_entitie

	for entitie in actual_entities_nodes:
		client_actual_entities.append(entitie)
		
	
	for entitie_id in client_actual_entities:
		if entitie_id in server_actual_entities:
			pass
		else:
			# print("Deleting...")
			var node = actual_entities_nodes[entitie_id]
			
			if node != null and is_instance_valid(node):
				
				node.queue_free()
				actual_entities_nodes.erase(entitie_id)
			else:
				# print("Canceled")
				pass

func actualize_states(model, state, node):
	if int(model) == 500001:
		
		var anim_player = node.get_node("model/AnimationPlayer")
		
		if anim_player and anim_player is AnimationPlayer:
			if state == "idle":
				anim_player.play("idle")
			elif state == "open": 
				anim_player.play("open")
