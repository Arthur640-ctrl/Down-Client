extends RayCast3D

@export var interact_text: CenterContainer

func detect_raycast(reach_max: float):
	if is_colliding():
		var collision_point = get_collision_point()
		var origin = global_transform.origin
		var distance = origin.distance_to(collision_point)

		if distance <= reach_max:
			var cible = get_collider()
			print("🎯 Cible détectée à", distance, "unités :", cible.name)
			return cible
		else:
			print("⚠ Trop loin :", distance, "unités")
	return null
	
func _process(delta: float) -> void:
	if is_colliding():
		var target = get_collider()
		var origin = global_transform.origin
		
		if target and origin:
			# Récupérer la position de l'objet cible
			var target_pos = target.global_transform.origin
			
			# Calculer la distance entre l'origine du raycast et la cible
			var distance = origin.distance_to(target_pos)
			
			#print("Touché :", target.name)		
			
			if target.is_in_group("interactable") and distance <= 5:
				interact_text.update_context("Ouvrir")
				interact_text.update_icon("interact")
				
			elif target.is_in_group("item") and distance <= 5:
				interact_text.update_context("Ramasser")
				interact_text.update_icon("interact")
			else:
				interact_text.reset()
				
			if Input.is_action_just_pressed("interact") and target.is_in_group("item") and distance <= 5:
				if target and target.has_method("pickup") and target.has_method("get_infos") and target.has_method("get_item_position"):
					var infos = target.get_infos()
					var position = target.get_item_position()
					$"../../../UI_GAME/inventory".add_item(infos, position)
					target.pickup()
