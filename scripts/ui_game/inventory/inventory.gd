extends Control


# ===== All Cases =====
# Active :
@onready var active_0: Sprite2D = $active/active_0
@onready var active_1: Sprite2D = $active/active_1
@onready var active_2: Sprite2D = $active/active_2
# Texture react :
@onready var rarity_active_0: TextureRect = $active/active_0/txt_active_0
@onready var rarity_active_1: TextureRect = $active/active_1/txt_active_1
@onready var rarity_active_2: TextureRect = $active/active_2/txt_active_2
@onready var item_active_0: TextureRect = $active/active_0/wepon_active_0
@onready var item_active_1: TextureRect = $active/active_1/wepon_active_1
@onready var item_active_2: TextureRect = $active/active_2/wepon_active_2

# ====================
var slot_select_size = Vector2(0.13, 0.13)
var slot_idle_size = Vector2(0.1, 0.1)
var actual_slot = null

# ====================
var rarity_texture_path = {
	0: "res://models/inventory/rarity/primitif.png",
	1: "res://models/inventory/rarity/traditionelle.png",
	2: "res://models/inventory/rarity/specialisé.png",
	3: "res://models/inventory/rarity/haut-gamme.png",
	4: "res://models/inventory/rarity/elite.png",
	5: "res://models/inventory/rarity/legendaire.png",
	6: "res://models/inventory/rarity/experimentale.png"
}

var weapon_cover = {
	100002: "res://.godot/imported/test.png-73e6866441acc63b545363ecd9f42f55.ctex"
}

var rarity_textures = {} # dictionnaire pour stocker les textures chargées

# ====================
func reset_texture_slot(bar: String, slot: int) -> void:
	if bar.to_lower() == "active":
		if slot == 0:
			rarity_active_0.texture = null
			item_active_0.texture = null
		elif slot == 1:
			rarity_active_1.texture = null
			item_active_1.texture = null
		elif slot == 2:
			rarity_active_2.texture = null
			item_active_2.texture = null

func _ready() -> void:
	# Charge les textures une fois au démarrage
	for rarity in rarity_texture_path.keys():
		rarity_textures[rarity] = load(rarity_texture_path[rarity])

func _process(delta: float) -> void:
	var inventory = Globals.inventory
	
	if inventory == null:
		return
	
	var i_slot = 0
	
	for slot in inventory["active"]:
		reset_texture_slot("active", i_slot)
		
		if typeof(slot) != TYPE_DICTIONARY or not slot.has("rarity"):
			i_slot += 1
			continue
		
		if slot["rarity"] != null:
			var rarity = int(slot["rarity"])
			
			if rarity_textures.has(rarity):
				var texture = rarity_textures[rarity]
				if i_slot == 0:
					rarity_active_0.texture = texture
				elif i_slot == 1:
					rarity_active_1.texture = texture
				elif i_slot == 2:
					rarity_active_2.texture = texture
		
		i_slot += 1
