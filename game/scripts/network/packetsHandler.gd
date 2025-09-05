extends Node

var player : Node = null
var is_connect : bool = false
var delta : float = 0.0

func set_connect_state(newState : bool) -> void:
	is_connect = newState

func register_player(nodePlayer : Node) -> void:
	player = nodePlayer

func handle(packet : Dictionary) -> void:
	if packet.has("message"):
		if packet["message"] == "word_actualisation":
			NetwordWordManager.word_actualisation(packet, player)
