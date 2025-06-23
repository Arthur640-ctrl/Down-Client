extends Node3D

@onready var player: CharacterBody3D = $Player

var udp = PacketPeerUDP.new()

var connected = false
var player_id = ""
var player_token = ""

func _ready():
	udp.connect_to_host("127.0.0.1", 8000)
	udp.set_dest_address("127.0.0.1", 8000)
	player_id = Globals.player_id
	player_token = Globals.player_token

func _process(_delta):
	if Globals.multiplayer:
		# Lecture des réponses du serveur
		while udp.get_available_packet_count() > 0:
			var response = udp.get_packet().get_string_from_utf8()
			# print("📩 Réponse reçue :", response)

			var json = JSON.new()
			var result = json.parse(response)
			if result == OK:
				var data = json.get_data()
				if data.has("message") and data["message"] == "Connexion réussie":
					connected = true
					print("✅ Client connecté.")
				elif data.has("message") and data["message"] == "word_actualisation":
					var players_data = data.get("players", {})
					if data.has("entities"):
						set_entities(data["entities"])
					for pid in players_data.keys():
						var infos = players_data[pid]
						var pos = infos.get("position", null)
						var rot = infos.get("rotation", null)
						var cam_rot = infos.get("camera_rotation", null)
						
						var stamina = infos.get("stamina", 100)
						var health = infos.get("health", 100)
						
						var actual_item = infos.get("actual_item", 100002)

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

								if pid == player_id:
									Globals.new_infos["position"] = position
									Globals.new_infos["rotation"] = rotation
									Globals.new_infos["camera_rotation"] = camera_rotation
									
									player.update_stamina(stamina)
									player.update_health(health)
									Globals.stamina = stamina
									Globals.health = health
									Globals.actual_item = actual_item
							else:
								print("⚠️ pos, rot ou cam_rot ont moins de 3 éléments pour player ", pid)
						else:
							print("❌ pos, rot ou cam_rot sont null pour player ", pid)
					set_other_players(players_data)
				
				elif data.has("message") and data["message"] == "died":
					pass

				

		if not connected:
			var login_packet = {
				"request": "login",
				"player_id": player_id,
				"player_token": player_token
			}
			udp.put_packet(JSON.stringify(login_packet).to_utf8_buffer())

		# Une fois connecté, on envoie les inputs
		if connected:
			if Globals.INPUT_DIR != null or Globals.EVENT_MOUSE != {}:
				var input_packet = {
					"request": "player_actualisation",
					"player_id": player_id,
					"input_dir": [Globals.INPUT_DIR.x, Globals.INPUT_DIR.y],
					"mouse_event": Globals.EVENT_MOUSE,
					"is_jumping": Globals.IS_JUMPING,
					"is_running": Globals.IS_RUNNING,
					"is_crouched": Globals.IS_CROUSHED,
					"is_shooting": Globals.IS_SHOOTING,
					
					"inv_up": Globals.INV_UP,
					"inv_down": Globals.INV_DOWN,
				}
				udp.put_packet(JSON.stringify(input_packet).to_utf8_buffer())
				Globals.EVENT_MOUSE = {}

func set_other_players(players_data: Dictionary) -> void:
	for pid in players_data.keys():
		if pid == player_id:
			continue  # Ignore le joueur local

		var infos = players_data[pid]
		var pos = infos.get("position", null)
		var rot = infos.get("rotation", null)
		var cam_rot = infos.get("camera_rotation", null)

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
			var player_scene = preload("res://scenes/other_player.tscn")
			var new_player = player_scene.instantiate()
			new_player.name = pid
			get_tree().current_scene.add_child(new_player)
			Globals.other_players[pid] = new_player
			print("✅ Autre joueur ajouté :", pid)

		# Mise à jour des positions
		var other = Globals.other_players[pid]
		other.global_position = position
		other.rotation_degrees = rotation
		
		var animation_packet = infos.get("animations", null)
		
		other.process_animations(animation_packet)

func set_entities(entities_data: Dictionary) -> void:
	Globals.entities = entities_data
