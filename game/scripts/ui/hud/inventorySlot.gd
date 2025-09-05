extends Node
class_name InventorySlot

@export var slotTexture : TextureRect
@export var slotRarityTexture : TextureRect
@export var isPassive : bool

const slotDefault: Texture2D = preload("res://game/assets/ui/inventory/slot_default.png")
const slotFocused: Texture2D = preload("res://game/assets/ui/inventory/slot_focused.png")

const rarityTextures : Dictionary = {
	0: preload("res://game/assets/ui/inventory/rarityCover/slot/1_primitif.png"),
	1: preload("res://game/assets/ui/inventory/rarityCover/slot/2_traditionnel.png"),
	2: preload("res://game/assets/ui/inventory/rarityCover/slot/3_spécialisées.png"),
	3: preload("res://game/assets/ui/inventory/rarityCover/slot/4_haut_de_gamme.png"),
	4: preload("res://game/assets/ui/inventory/rarityCover/slot/5_élites.png"),
	5: preload("res://game/assets/ui/inventory/rarityCover/slot/6_légendaires.png"), 
	6: preload("res://game/assets/ui/inventory/rarityCover/slot/7_experimentales.png")
}

func set_focused(focused: bool) -> void:
	if isPassive:
		return
	else:
		if focused:
			slotTexture.texture = slotFocused
		else:
			slotTexture.texture = slotDefault

func change_rarity(rarity: int) -> void:
	slotRarityTexture.texture = rarityTextures[rarity]

func _ready() -> void:
	slotRarityTexture.texture = null
