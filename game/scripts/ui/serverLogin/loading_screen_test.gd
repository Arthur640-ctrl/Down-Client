extends Control

@onready var input_player_id: LineEdit = $player_id
@onready var input_token: LineEdit = $token

var player_id = ""
var player_token = ""

func _on_player_id_text_changed(new_text: String) -> void:
	player_id = new_text
	print(player_id)
	
func _on_token_text_changed(new_text: String) -> void:
	player_token = new_text
	print(player_token)

func _on_button_pressed() -> void:
	Globals.player_id = player_id
	Globals.player_token = player_token
	get_tree().change_scene_to_file("res://game/scenes/main.tscn")
