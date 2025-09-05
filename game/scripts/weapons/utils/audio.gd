extends Node3D

@onready var audio_use: AudioStreamPlayer3D = $audio_use

var weapons = {
	100001: {
		"type": "gun",
		"shoot": "res://game/models/audio/100002/shoot.mp3",
		"empty_shoot": "res://game/models/audio/100002/empty_shoot.wav",
	}
}

func play_sound_use(actual_slot: int):
	if Globals.inventory != null:
		if Globals.inventory["inventory"]["active"][actual_slot]["item"]:
			var item_id = int(Globals.inventory["inventory"]["active"][actual_slot]["item"])

			if weapons.has(item_id) and weapons[item_id]["type"] == "gun":
				var stream = load(weapons[item_id]["shoot"])
				audio_use.stop()
				audio_use.stream = stream
				audio_use.play()
