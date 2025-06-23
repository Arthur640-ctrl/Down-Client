extends Node

var last_settings_json = ""

# var settings = {
#	"main": {
#		"language": "en",
#		"system_alerts": "true",
#		"show_tutorials": "false"
#	},
#	"video": {
#		"graphics_quality": "low",
#		"vsync": "false",
#		"display_mode": "full",
#		"fps_limit": "180",
#	},
#	"audio": {
#		"general_volume": "80",
#		"effects_volume": "50",
#		"dialogues_volume": "20",
#		"musics_volume": "40",
#	},
#	"inputs": {
#		"sens_x": "0.2",
#		"sens_y": "0.2",
#		"reverse_y": "false",
#		
#		"action_forward": "Right",
#		"action_backward": "s",
#		"action_right": "d",
#		"action_left": "q"
#	}
#}

func clear_keyboard_and_mouse_events(action_name: String):
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey or event is InputEventMouseButton:
			InputMap.action_erase_event(action_name, event)

func clear_joypad_events(action_name: String):
	for event in InputMap.action_get_events(action_name):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			InputMap.action_erase_event(action_name, event)

func change_language(locale_code: String) -> void:
	TranslationServer.set_locale(locale_code)

func percent_to_db(percent: float) -> float:
	if percent <= 0:
		return -80.0  # silence
	return 20.0 * log(percent / 100.0) / log(10.0)  # log base 10

func str_to_bool(value: String) -> bool:
	value = value.strip_edges().to_lower()
	return value == "true" or value == "1" or value == "yes"

func _process(delta: float) -> void:
	#load_settings()
	pass

func _ready() -> void:
	pass

func apply_vsync(enabled: bool):
	if enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func apply_bindings(action_name: String) -> void:
	var inputs = Globals.settings["inputs"].get("action_" + action_name, null)
	if inputs == null:
		print("Aucune config pour l'action: ", action_name)
		return
	
	# Récupérer tous les events déjà associés à l'action dans InputMap
	var current_events = InputMap.action_get_events(action_name)
	
	# Séparer clavier et manette dans les events actuels
	var current_keyboard_events = []
	var current_controller_events = []
	
	for ev in current_events:
		if ev is InputEventKey or ev is InputEventMouseButton:
			current_keyboard_events.append(ev)
		elif ev is InputEventJoypadButton or ev is InputEventJoypadMotion:
			current_controller_events.append(ev)

	# 🔹 Gérer clavier
	if inputs.has("keyboard"):
		# Supprimer les events clavier actuels
		for ev in current_keyboard_events:
			InputMap.action_erase_event(action_name, ev)
		
		# Ajouter nouveau si pas null
		if inputs["keyboard"] != null:
			InputMap.action_add_event(action_name, inputs["keyboard"])

	# 🔹 Gérer manette
	if inputs.has("controller"):
		# Supprimer les events manette actuels
		for ev in current_controller_events:
			InputMap.action_erase_event(action_name, ev)

		# Ajouter nouveau si pas null
		if inputs["controller"] != null:
			InputMap.action_add_event(action_name, inputs["controller"])

func load_settings():
	var settings = Globals.settings
	var json = JSON.new()
	var current_json = json.stringify(settings)

	if last_settings_json == current_json:
		return
	else:
		last_settings_json = current_json

	# ===== Main settings : =====
	change_language(settings["main"]["language"])
	
	# Video
	Engine.max_fps = int(settings["video"]["fps_limit"])
	apply_vsync(str_to_bool(settings["video"]["vsync"]))
	
	if settings["video"]["display_mode"] == "full":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Audio
	var bus_index_general = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index_general, percent_to_db(float(settings["audio"]["general_volume"])))
	
	var bus_index_musics = AudioServer.get_bus_index("Musics")
	AudioServer.set_bus_volume_db(bus_index_musics, percent_to_db(float(settings["audio"]["musics_volume"])))
	
	var bus_index_sfx = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_volume_db(bus_index_sfx, percent_to_db(float(settings["audio"]["effects_volume"])))
	
	# ===== Input =====
	var actions_on_settings = settings["inputs"]
	var actions = []

	for action in actions_on_settings:
		if not str(action).begins_with("action_"):
			continue
		else:
			var action_name = str(action).trim_prefix("action_")
			actions.append(action_name)
	
	for action in actions:
		apply_bindings(action)
		
	var slider_percent_x = float(settings["inputs"]["sens_x_percent"])
	var min_sens_x = 0.05
	var max_sens_x = 0.5
	Globals.sens_x = lerp(min_sens_x, max_sens_x, slider_percent_x / 100.0)

	var slider_percent_y = float(settings["inputs"]["sens_y_percent"])
	var min_sens_y = 0.05
	var max_sens_y = 0.5
	Globals.sens_y = lerp(min_sens_y, max_sens_y, slider_percent_y / 100.0)
	
	var reverse_y = str_to_bool(settings["inputs"]["reverse_y"])
	Globals.invert_y = reverse_y
