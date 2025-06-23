extends Control


# ===== All Cases =====
# Active :
@onready var active_0: Sprite2D = $active/active_0
@onready var active_1: Sprite2D = $active/active_1
@onready var active_2: Sprite2D = $active/active_2
# Texture react :
@onready var txt_active_0: TextureRect = $active/active_0/txt_active_0
@onready var txt_active_1: TextureRect = $active/active_1/txt_active_1
@onready var txt_active_2: TextureRect = $active/active_2/txt_active_2
@onready var wepon_active_0: TextureRect = $active/active_0/wepon_active_0
@onready var wepon_active_1: TextureRect = $active/active_1/wepon_active_1
@onready var wepon_active_2: TextureRect = $active/active_2/wepon_active_2
# ====================
var active_0_empty = false
var active_1_empty = false
var active_2_empty = false
# ====================
var slot_select_size = Vector2(0.13, 0.13)
var slot_idle_size = Vector2(0.1, 0.1)
var actual_slot = null
# ====================
var rarity_texture_path = {
	"primitif": "res://models/inventory/rarity/primitif.png",
	"traditionnelle": "res://models/inventory/rarity/traditionelle.png",
	"specialisé": "res://models/inventory/rarity/specialisé.png",
	"haut-gamme": "res://models/inventory/rarity/haut-gamme.png",
	"elite": "res://models/inventory/rarity/elite.png",
	"legendaire": "res://models/inventory/rarity/legendaire.png",
	"experimentale": "res://models/inventory/rarity/experimentale.png"
}
var animation_needed_for_weapon = {
	"Stalker-47": "generic_rifle"
}
var weapon_cover = {
	"Stalker-47": "res://.godot/imported/test.png-73e6866441acc63b545363ecd9f42f55.ctex"
}
# ====================
@export var inventory = {
	"active":
		[
			{
				"item": "Stalker-47",
				"number": null,
				"rarity": "haut-gamme"
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			}
		],
	"passive":
		[
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			}
		]
}
# ====================
func reset():
	for slot in inventory["active"]:
		slot["item"] = null
		slot["number"] = null
		slot["rarity"] = null
		
	for slot in inventory["passive"]:
		slot["item"] = null
		slot["number"] = null
		slot["rarity"] = null
		
	txt_active_0.texture = null
	txt_active_1.texture = null
	txt_active_2.texture = null
	wepon_active_0.texture = null
	wepon_active_1.texture = null
	wepon_active_2.texture = null
	
	active_0.scale = slot_idle_size
	active_1.scale = slot_idle_size
	active_2.scale = slot_idle_size
	
	active_0_empty = true
	active_1_empty = true
	active_2_empty = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_down"):
		if actual_slot == null:
			actual_slot = 0
		else:
			if actual_slot == 2:
				actual_slot = 0
			else:
				actual_slot += 1
				
	if Input.is_action_just_pressed("inventory_up"):
		if actual_slot == null:
			actual_slot = 0
		else:
			if actual_slot == 0:
				actual_slot = 2
			else:
				actual_slot -= 1
	
	set_current_slot()
	load_inventory()
	set_current_hand()

func _ready() -> void:
	reset()

func set_current_slot():
	if actual_slot == 0:
		active_0.scale = slot_select_size
		active_1.scale = slot_idle_size
		active_2.scale = slot_idle_size
	elif actual_slot == 1:
		active_0.scale = slot_idle_size
		active_1.scale = slot_select_size
		active_2.scale = slot_idle_size
	elif actual_slot == 2:
		active_0.scale = slot_idle_size
		active_1.scale = slot_idle_size
		active_2.scale = slot_select_size
	else:
		active_0.scale = slot_idle_size
		active_1.scale = slot_idle_size
		active_2.scale = slot_idle_size

func slot_is_empty(slot):
	if inventory["active"][slot]["item"] == null and inventory["active"][slot]["rarity"] == null and inventory["active"][slot]["number"] == null:
		return true
	else:
		return false

func load_inventory():
	var i = 0
	for slot in inventory["active"]:
		for rarity_texture in rarity_texture_path:
			if rarity_texture == slot["rarity"]:
				if i == 0:
					txt_active_0.texture = load(rarity_texture_path[rarity_texture])
				elif i == 1:
					txt_active_1.texture = load(rarity_texture_path[rarity_texture])
				elif i == 2:
					txt_active_2.texture = load(rarity_texture_path[rarity_texture])
		
		for cover in weapon_cover:
			if cover == slot["item"]:
				if i == 0:
					wepon_active_0.texture = load(weapon_cover[cover])
				elif i == 1:
					wepon_active_1.texture = load(weapon_cover[cover])
				elif i == 2:
					wepon_active_2.texture = load(weapon_cover[cover])
				
		i += 1

func set_current_hand():
	if actual_slot != null and !slot_is_empty(actual_slot):
		
		var item = inventory["active"][actual_slot]["item"]
		var rarity = inventory["active"][actual_slot]["rarity"]
		var number = inventory["active"][actual_slot]["number"]
		var animation_needed = null
		
		for animation in animation_needed_for_weapon:
			if animation == item:
				animation_needed = animation_needed_for_weapon[animation] 
		
		$"../..".current_hand = {
			"item": item,
			"rarity": rarity,
			"number": number,
			"animation_needed": animation_needed
		}
		
	else:
		$"../..".current_hand = null

func add_item(item: Dictionary, drop_position: Vector3) -> bool:
	if actual_slot != null:
		if !slot_is_empty(actual_slot):
			# Drop l'objet actuel à la position du ramassage
			drop_item(inventory["active"][actual_slot], inventory["active"][actual_slot]["item"], drop_position)
		
		inventory["active"][actual_slot] = item
		return true
	else:
		for i in range(inventory["active"].size()):
			if slot_is_empty(i):
				inventory["active"][i] = item
				return true
		
		drop_item(inventory["active"][0], inventory["active"][0]["item"], drop_position)
		inventory["active"][0] = item
		return true

func drop_item(old_item_data: Dictionary, item: String, drop_position: Vector3) -> void:
	var drop_scene = null
	if item == "Stalker-47":
		drop_scene = preload("res://scenes/weapons/item/item_stalker_47.tscn")
	
	var drop_instance = drop_scene.instantiate()
	
	drop_instance.set_meta("rarity", old_item_data.get("rarity", null))
	drop_instance.set_meta("item", old_item_data.get("item", null))
	drop_instance.set_meta("number", old_item_data.get("number", null))
	
	get_parent().add_child(drop_instance)
	drop_instance.global_transform.origin = drop_position
