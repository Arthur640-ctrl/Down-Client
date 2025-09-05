extends Node3D
@onready var audio_use: AudioStreamPlayer3D = $"../../../../../../audio_use"
# ============ VARIABLES ============
var model_weapons = {
	100001: {
		"position": Vector3(1.283, 17.604, 2.024),
		"rotation": Vector3(84.0, 33.9, -56.3),
		"scale": Vector3(310.0, 310.0, 310.0),
		"type": "gun",
	}
}

var audio_weapons = {
	100001: {
		"type": "gun",
		"shoot": "res://game/models/audio/100002/shoot.mp3",
		"empty_shoot": "res://game/models/audio/100002/empty_shoot.wav",
	}
}

var actual = 0
var shooting = false
var glb_actual_slot = 0
var glb_inventory = null
# ============ FONCTIONS ============
func get_item_path(id):
	if id == 100001:
		return "res://game/scenes/weapons/guns/100001.tscn"

func reset():
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
func _ready() -> void:
	reset()

func add_item(item_id: int):
	if item_id != actual:
		reset()
		var path = get_item_path(item_id)
		
		if path != null:
			var item = load(path)
			var instance = item.instantiate()
			
			instance.position = model_weapons[item_id]["position"]
			instance.rotation_degrees = model_weapons[item_id]["rotation"]
			instance.scale = model_weapons[item_id]["scale"]
			
			add_child(instance)
			
			actual = item_id

func process_weapon_pivot(actual_slot, inventory) -> void:
	if inventory != null:
		if inventory["active"][int(actual_slot)]["item"] != null:
			add_item(int(inventory["active"][int(actual_slot)]["item"]))
		else:
			actual = 0
			reset()
	
	if shooting:
		if actual != 0:
			if model_weapons[actual]["type"] == "gun":
				for child in get_children():
					if child.has_method("add_muzzle_flash"):
						child.add_muzzle_flash()
						
	glb_actual_slot = actual_slot
	glb_inventory = inventory

func maj_shooting(new):
	shooting = new

func play_sound_use(actual_slot: int):
	if glb_inventory != null:
		if glb_inventory["active"][actual_slot]["item"]:
			var item_id = int(glb_inventory["active"][actual_slot]["item"])

			if audio_weapons.has(item_id) and audio_weapons[item_id]["type"] == "gun":
				var stream = load(audio_weapons[item_id]["shoot"])
				audio_use.stop()
				audio_use.stream = stream
				audio_use.play()

func _process(delta: float) -> void:
	if shooting and glb_inventory != null:
		play_sound_use(glb_actual_slot)
