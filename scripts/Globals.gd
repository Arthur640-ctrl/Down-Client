extends Node

var INPUT_DIR = null
var PLAYER_CAM_CURRENT = true

var IS_RUNNING = false
var IS_CROUSHED = false
var IS_JUMPING = false
var IS_SHOOTING = false

var INV_UP = false
var INV_DOWN = false

var maintain_for_croushed = false
var maintain_for_aiming = false

# Multiplayers :
var PREDICTION = true # ESSENTIAL !!!
var MULTIPLAYER = true

var EVENT_MOUSE = {}

var all_players_infos = {}
var other_players = {}

var new_infos = {
	"position": Vector3(0, 0, 0),
	"rotation": Vector3(0, 0, 0),
	"camera_rotation": Vector3(0, 0, 0)
}

var actual_slot = 0

var player_id = ""
var player_token = ""

var stamina = 0
var health = 0

var DELTA = 0

var state = "lobby"

var sens_x = 0.2
var sens_y = 0.2
var invert_y := false

var inventory = null

# ====================================
var entities = {}
# ====================================

var settings_location = ""

var settings = {
	"main": {
		"language": "en",
		"system_alerts": "true",
		"show_tutorials": "false"
	},
	"video": {
		"graphics_quality": "low",
		"vsync": "false",
		"display_mode": "windowed",
		"fps_limit": "180",
	},
	"audio": {
		"general_volume": "80",
		"effects_volume": "50",
		"dialogues_volume": "20",
		"musics_volume": "40",
	},
	"inputs": {
		"sens_x_percent": "0.2",
		"sens_y_percent": "0.2",
		"reverse_y": "false",
		"maintain_for_croushed": "true",
		"maintain_for_aiming": "false",
		"controller_vibrations": "true",

		
		"action_forward": {
			"keyboard": null,
			"controller": null
		},
		"action_backward": {
			"keyboard": null,
			"controller": null
		},
		"action_right": {
			"keyboard": null,
			"controller": null
		},
		"action_left": {
			"keyboard": null,
			"controller": null
		},
		"action_interact": {
			"keyboard": null,
			"controller": null
		}
	}
}

func _ready():
	var connected_pads = Input.get_connected_joypads()
	for pad_id in connected_pads:
		var pad_name = Input.get_joy_name(pad_id)
		if pad_name.to_lower().find("vjoy") != -1:
			continue  # On ignore les fausses manettes vJoy
		print("🎮 Manette détectée :", pad_name)
		_check_gamepad_brand(pad_name)
		return
	print("⌨️ Aucune manette réelle détectée, clavier/souris utilisé")
	controler = "unckown"

var controler = ""

func _check_gamepad_brand(name: String):
	name = name.to_lower()
	if name.find("xbox") != -1:
		print("🟩 Manette Xbox détectée")
		controler = "xbox"
	elif name.find("playstation") != -1 or name.find("ps") != -1:
		print("🟦 Manette PlayStation détectée")
		controler = "ps"
	elif name.find("switch") != -1 or name.find("pro controller") != -1:
		print("🔴 Manette Nintendo Switch détectée")
		controler = "switch"
	else:
		print("🎮 Manette inconnue :", name)
		controler = "unckown"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print("Interact")
		



	
