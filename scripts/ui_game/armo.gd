extends Control

@onready var total: Label = $total
@onready var in_magazine: Label = $in_magazine

var player = null

func _ready():
	player = get_node("/root/word/player")

	if player:
		print("Player trouvé !")
	else:
		print("Player non trouvé, vérifie le chemin du nœud.")

func _process(delta: float) -> void:
	var current_hand = player.current_hand
	var amo_stock = player.ammo_inventory
	
	if current_hand != null:
		if current_hand["amo_type"]:
			total.text = "/ " + str(amo_stock[current_hand["amo_type"]])
	else:
		total.text = "/ 0"
	in_magazine.text = str(player.current_magazine)
	
