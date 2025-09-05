extends CanvasLayer

# Slots
@onready var activeSlot0: InventorySlot = $Control/Active/slot0
@onready var activeSlot1: InventorySlot = $Control/Active/slot1
@onready var passiveSlot0: InventorySlot = $Control/Passive/slot0
@onready var passiveSlot1: InventorySlot = $Control/Passive/slot1
@onready var passiveSlot2: InventorySlot = $Control/Passive/slot2

# Infos
@onready var rarityTexture: TextureRect = $Control/Infos/base_slot/rarity
@onready var nameLabel: Label = $Control/Infos/base_slot/text_name/Label
@onready var rarityLabel: Label = $Control/Infos/base_slot/text_rarity/Label
@onready var infosBaseSlot: TextureRect = $Control/Infos/base_slot
@onready var allCountLabel: Label = $Control/Infos/base_slot/text_all_count/Label
@onready var countLabel: Label = $Control/Infos/base_slot/text_count/Label

var ammo_blink_tween_mag : Tween = null  # pour le magazine
var ammo_blink_tween_total : Tween = null  # pour la munition totale

var activesSlots: Array
var passivesSlots: Array

const defaultTextureInfos = preload("res://game/assets/ui/inventory/slot_infos.png")

const rarityTextures : Dictionary = {
	0: preload("res://game/assets/ui/inventory/rarityCover/infos/1.png"),
	1: preload("res://game/assets/ui/inventory/rarityCover/infos/2.png"),
	2: preload("res://game/assets/ui/inventory/rarityCover/infos/3.png"),
	3: preload("res://game/assets/ui/inventory/rarityCover/infos/4.png"),
	4: preload("res://game/assets/ui/inventory/rarityCover/infos/5.png"),
	5: preload("res://game/assets/ui/inventory/rarityCover/infos/6.png"), 
	6: preload("res://game/assets/ui/inventory/rarityCover/infos/7.png")
}

func _ready():
	activesSlots = [activeSlot0, activeSlot1]
	passivesSlots = [passiveSlot0, passiveSlot1, passiveSlot2]


func _process(delta: float) -> void:
	var inventory = Globals.inventory
	var actualSlot = Globals.actual_slot
	if inventory != null:
		actualize_inventory(inventory, actualSlot)
		actualize_slot_info(inventory, actualSlot)

func actualize_inventory(inventory : Dictionary, actualSlot : int) -> void:
	# Actual Slot :
	for i in range(activesSlots.size()):
		if i == actualSlot:
			activesSlots[i].set_focused(true)
		else:
			activesSlots[i].set_focused(false)

	# Rarity Active :
	var slotActive = 0
	for slot in inventory["active"]:
		if slotActive >= activesSlots.size():
			break
			
		var rarity = slot["rarity"]
		
		if rarity != null:
			activesSlots[slotActive].change_rarity(int(slot["rarity"]))
		slotActive += 1
	
	# Passive Slot : 
	var slotPassive = 0
	for slot in inventory["passive"]:
		if slotPassive >= activesSlots.size():
			break
			
		var rarity = slot["rarity"]
		
		if rarity != null:
			activesSlots[slotPassive].change_rarity(int(slot["rarity"]))
		slotPassive += 1 

func actualize_slot_info(inventory : Dictionary, actualSlot : int) -> void:
	if inventory["active"][actualSlot]["item"] == null:
		nameLabel.visible = false
		rarityLabel.visible = false
		
		rarityTexture.visible = false
		infosBaseSlot.visible = false
		return
	
	nameLabel.visible = true
	rarityLabel.visible = true
	
	rarityTexture.visible = true
	infosBaseSlot.visible = true
	
	var slot : Dictionary = inventory["active"][actualSlot]
	var item : Dictionary = Items.items[int(slot["item"])]
	
	var itemName : String = item["display_name"]
	var itemRarity : String = get_rarity_name(slot["rarity"])
	
	nameLabel.text = itemName
	rarityLabel.text = itemRarity
	
	rarityLabel.add_theme_color_override("font_color", Color("#FF00FF"))
	
	rarityTexture.texture = rarityTextures[int(slot["rarity"])]
	
	if item["type"] == "gun":
		countLabel.text = str(int(slot["number"]))
		allCountLabel.text = str(int(inventory["bullets"][str(item["ammos"])]))
		
		# Blink magazine
		if slot["number"] <= 5:
			start_ammo_blink_mag()
		else:
			stop_ammo_blink_mag()
		
		# Blink total
		if inventory["bullets"][str(item["ammos"])] <= 5:
			start_ammo_blink_total()
		else:
			stop_ammo_blink_total()
	else:
		countLabel.text = ""
		allCountLabel.text = ""

func get_rarity_name(rarity : int) -> String:
	if rarity == 1:
		return "Primitif"
	elif rarity == 2:
		return "Traditionnel"
	elif rarity == 3:
		return "Spécialisé"
	elif rarity == 4:
		return "Haut-de-gamme"
	elif rarity == 5:
		return "Élite"
	elif rarity == 6:
		return "Légendaire"
	elif rarity == 7:
		return "Expérimental"
	else:
		return "None"

func start_ammo_blink_mag():
	if ammo_blink_tween_mag != null:
		return

	ammo_blink_tween_mag = create_tween()
	ammo_blink_tween_mag.set_loops()
	var t1 = ammo_blink_tween_mag.tween_property(countLabel, "modulate", Color.RED, 0.5)
	t1.set_trans(Tween.TRANS_SINE)
	t1.set_ease(Tween.EASE_IN_OUT)
	var t2 = ammo_blink_tween_mag.tween_property(countLabel, "modulate", Color.WHITE, 0.5)
	t2.set_trans(Tween.TRANS_SINE)
	t2.set_ease(Tween.EASE_IN_OUT)

func stop_ammo_blink_mag():
	if ammo_blink_tween_mag != null:
		ammo_blink_tween_mag.kill()
		ammo_blink_tween_mag = null
		countLabel.modulate = Color.WHITE

func start_ammo_blink_total():
	if ammo_blink_tween_total != null:
		return

	ammo_blink_tween_total = create_tween()
	ammo_blink_tween_total.set_loops()
	var t1 = ammo_blink_tween_total.tween_property(allCountLabel, "modulate", Color.RED, 0.5)
	t1.set_trans(Tween.TRANS_SINE)
	t1.set_ease(Tween.EASE_IN_OUT)
	var t2 = ammo_blink_tween_total.tween_property(allCountLabel, "modulate", Color.WHITE, 0.5)
	t2.set_trans(Tween.TRANS_SINE)
	t2.set_ease(Tween.EASE_IN_OUT)

func stop_ammo_blink_total():
	if ammo_blink_tween_total != null:
		ammo_blink_tween_total.kill()
		ammo_blink_tween_total = null
		allCountLabel.modulate = Color.WHITE
