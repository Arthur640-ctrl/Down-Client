extends Node3D

# ==========================================================
# 📜 WEAPON_PIVOT .GD
# ----------------------------------------------------------
# 🎯 Description:
# Instancie les armes/items dans la main du joueur et
# ajoute un muzzle flash quand nécessaire
# ==========================================================

# ============================
# 🔗 Node references
# ============================
@onready var animationTree: AnimationTree = $"../../../../animation tree"

@onready var IKhandLeft: SkeletonIK3D = $"../../HandLeft"
@onready var IKhandRight: SkeletonIK3D = $"../../HandRight"
@onready var markerHandLeft: Marker3D = $"../../../../../../MarkerHandLeft"
@onready var markerHandRight: Marker3D = $"../../../../../../MarkerHandRight"

# ============================
# 🧠 Internal variables
# ============================
var currentItem : int = 0

var gunAttachmentAnimation : String = "parameters/attacment/transition_request"
var magAttachmentState : String = "parameters/m_state/transition_request"
var gunBlend : String = "parameters/gun_blend/blend_amount"

var weaponNodeLeft : Marker3D = null
var weaponNodeRight : Marker3D = null
# ============================
# 🔁 Functions
# ============================
func getItemPath(id : int) -> Variant:
	# Return the path of the item thanks to the id
	return Items.items[int(id)]["path"]

func resetHand() -> void:
	# Remove all node of the player's hand
	for child in get_children():
		remove_child(child)
		child.queue_free()

func _ready() -> void:
	resetHand()

func addItem(item_id: int) -> void:
	# Reset the hand and get the item path
	resetHand()
	var itemPath = getItemPath(item_id)

	if itemPath != null:
		# Instantiate the item and apply rotation, position & scale
		var itemInstance = itemPath.instantiate()
		
		itemInstance.position = Items.items[item_id]["handPosition"]
		itemInstance.rotation_degrees = Items.items[item_id]["handRotation"]
		itemInstance.scale = Items.items[item_id]["handScale"]
		
		animationTree[gunAttachmentAnimation] = Items.items[item_id]["attachment"]
		
		add_child(itemInstance)
		
		weaponNodeLeft = itemInstance.get_node("lh")
		weaponNodeRight = itemInstance.get_node("rh")
		
		IKhandLeft.start()
		
		
		# Add child and set the current item
		currentItem = item_id

func have_gun() -> bool:
	if Globals.inventory == null:
		return false

	var slot := int(Globals.actual_slot)
	var slot_data = Globals.inventory["active"][slot]
	var item_id = slot_data["item"]
	
	if item_id != null:
		item_id = int(item_id)
	
	if item_id == null:
		return false
	
	if Items.items.has(item_id) and Items.items[item_id]["type"] == "gun":
		return true
	return false

func _process(delta: float) -> void:
	if Globals.inventory != null:
		var itemToSet = Globals.inventory["active"][int(Globals.actual_slot)]["item"]

		if itemToSet != null:
			if itemToSet != currentItem:
				# If the item is valid and not already equipped, it is equipped to the player.
				addItem(int(Globals.inventory["active"][int(Globals.actual_slot)]["item"]))
		else:
			# Else just reset the hand and set the current item to null
			currentItem = 0
			IKhandLeft.stop()
			IKhandRight.stop()
			
			resetHand()

	if have_gun():
		animationTree[gunBlend] = 1.0
		if Input.is_action_pressed("aiming"):
			animationTree[magAttachmentState] = "aiming"
		else:
			animationTree[magAttachmentState] = "idle"
	else:
		animationTree[gunBlend] = 0.0
		
	if weaponNodeLeft != null and weaponNodeRight != null:
		markerHandLeft.global_position  = weaponNodeLeft.global_position 
		markerHandRight.global_position  = weaponNodeRight.global_position 
		
		copy_rotation_no_scale(markerHandLeft, weaponNodeLeft)
		copy_rotation_no_scale(markerHandRight, weaponNodeRight)
		
		# print("Marker : ", markerHandLeft.global_rotation, " Node : ", weaponNodeLeft.global_rotation)

# copie rotation (sans scale) + position
func copy_rotation_no_scale(marker: Node3D, weapon_node: Node3D) -> void:
	# forcer un scale neutre sur le marker (sécurité)
	marker.scale = Vector3.ONE

	# récupère la basis (rotation+scale) du weapon, on orthonormalise pour garder QUE la rotation
	var weapon_basis = weapon_node.global_transform.basis.orthonormalized()
	var weapon_origin = weapon_node.global_transform.origin

	# crée un Transform3D rotation-only + position et assigne en global
	var t := Transform3D(weapon_basis, weapon_origin)
	marker.global_transform = t
