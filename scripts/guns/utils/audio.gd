extends Node3D

@onready var audio_use: AudioStreamPlayer3D = $audio_use

var weapons = {
	100002: {
		"type": "gun",
		"shoot": "res://models/audio/100002/shoot.mp3",
		"empty_shoot": "res://models/audio/100002/empty_shoot.wav",
	}
}

func play_sound_use(item_id: int):
	if item_id == 0:
		return

	if weapons[item_id]["type"] == "gun":
		var stream = load(weapons[item_id]["shoot"])
		audio_use.stop()
		audio_use.stream = stream
		audio_use.play()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		if Globals.actual_item != 0:
			play_sound_use(Globals.actual_item)
