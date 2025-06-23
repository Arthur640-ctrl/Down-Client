extends Node3D

# ============ VARIABLES ============

var weapons = {
	100002: {
		"position": Vector3(1.283, 17.604, 2.024),
		"rotation": Vector3(84.0, 33.9, -56.3),
		"scale": Vector3(310.0, 310.0, 310.0),
		"type": "gun",
	}
}

var actual = 0
# ============ FONCTIONS ============
func get_item_path(id):
	if id == 100002:
		return "res://scenes/weapons/guns/100002.tscn"

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
			
			instance.position = weapons[item_id]["position"]
			instance.rotation_degrees = weapons[item_id]["rotation"]
			instance.scale = weapons[item_id]["scale"]
			
			add_child(instance)
			
			actual = item_id

func _process(delta: float) -> void:
	if Globals.actual_item != 0:
		add_item(Globals.actual_item)

	if Input.is_action_pressed("fire"):
		if actual != 0:
			if weapons[actual]["type"] == "gun":
				for child in get_children():
					if child.has_method("add_muzzle_flash"):
						child.add_muzzle_flash()
