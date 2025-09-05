extends Node

signal send_input_packet(inputs : Dictionary, isJson : bool)

func _process(delta: float) -> void:
	if PacketsHandler.is_connect == true:
		pass
