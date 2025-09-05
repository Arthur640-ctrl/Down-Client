extends Node

var delta : float = 0.0
var smoothing : float = 8.0

func word_actualisation(data : Dictionary, player : Node) -> void:
	var players_data = data.get("players", {})
	if data.has("entities"):
		if data["entities"] != null:
			set_entities(data["entities"])
		
	for pid in players_data.keys():
		var infos = players_data[pid]
		var pos = infos.get("position", null)
		var rot = infos.get("rotation", null)
		var cam_rot = infos.get("camera_rotation", null)
		
		var stamina = infos.get("stamina", 100)
		var health = infos.get("health", 100)
		
		var actual_slot = infos.get("actual_slot", 0)
		var inventory = infos.get("inventory", null)
		
		var is_blocked = infos.get("blocked", true)
		
		var is_now_reloading = infos.get("is_now_reloading")

		
		if pos != null and rot != null and cam_rot != null:
			if pos.size() >= 3 and rot.size() >= 3 and cam_rot.size() >= 3:
				var position = Vector3(pos[0], pos[1], pos[2])
				var rotation = Vector3(rot[0], rot[1], rot[2])
				var camera_rotation = Vector3(cam_rot[0], cam_rot[1], cam_rot[2])

				Globals.all_players_infos[pid] = {
					"position": position,
					"rotation": rotation,
					"camera_rotation": camera_rotation
				}

				if pid == Globals.player_id:
					Globals.new_infos["position"] = position
					Globals.new_infos["rotation"] = rotation
					Globals.new_infos["camera_rotation"] = camera_rotation
					
					player.update_stamina(stamina)
					player.update_health(health)
					Globals.stamina = stamina
					Globals.health = health
					Globals.actual_slot = int(actual_slot)
					Globals.inventory = inventory
					
					Globals.blocked = is_blocked
					Globals.is_now_reloading = is_now_reloading
					
			else:
				print("⚠️ pos, rot ou cam_rot ont moins de 3 éléments pour player ", pid)
		else:
			print("❌ pos, rot ou cam_rot sont null pour player ", pid)
	set_other_players(players_data)

func set_other_players(players_data: Dictionary) -> void:
	for pid in players_data.keys():
		if pid == Globals.player_id:
			continue  # Ignore le joueur local

		var infos = players_data[pid]
		var pos = infos.get("position", null)
		var rot = infos.get("rotation", null)
		var cam_rot = infos.get("camera_rotation", null)
		var health = infos.get("health", 100)
		if health <= 0:
			if Globals.other_players.has(pid):
				Globals.other_players[pid].queue_free()
				Globals.other_players.erase(pid)
				print("💀 Joueur mort supprimé :", pid)
			continue
		
		if pos == null or rot == null or cam_rot == null:
			print("❌ Données manquantes pour", pid)
			continue

		if pos.size() < 3 or rot.size() < 3 or cam_rot.size() < 3:
			print("⚠️ Données incomplètes pour", pid)
			continue

		var position = Vector3(pos[0], pos[1], pos[2])
		var rotation = Vector3(rot[0], rot[1], rot[2])
		var camera_rotation = Vector3(cam_rot[0], cam_rot[1], cam_rot[2])

		# Ajout ou récupération du joueur
		if not Globals.other_players.has(pid):
			var player_scene = preload("res://game/scenes/other_player.tscn")
			var new_player = player_scene.instantiate()
			new_player.name = pid
			get_tree().current_scene.add_child(new_player)
			Globals.other_players[pid] = new_player
			print("✅ Autre joueur ajouté :", pid)

		# Mise à jour des positions
		var other = Globals.other_players[pid]
		other.global_position = other.global_position.lerp(position, delta * smoothing)
		other.rotation_degrees = other.rotation_degrees.lerp(rotation, delta * smoothing)
		
		if other.has_node("camera_mount"):
			var camera_mount = other.get_node("camera_mount")
			camera_mount.rotation_degrees = camera_rotation

		
		var animation_packet = infos.get("animations", null)
		other.process_animations(animation_packet)
		
		var actual_slot = infos.get("actual_slot", 0)
		var inventory = infos.get("inventory", null)
		
		other.process_weaponpivot(actual_slot, inventory)

func set_entities(entities_data) -> void:
	Globals.entities = entities_data
