extends TextureRect

@onready var btn_settings_main: TextureButton = $btn_settings_main
@onready var btn_settings_video: TextureButton = $btn_settings_video
@onready var btn_settings_audio: TextureButton = $btn_settings_audio
@onready var btn_settings_inputs: TextureButton = $btn_settings_inputs
@onready var btn_settings_network: TextureButton = $btn_settings_network
@onready var btn_settings_social: TextureButton = $btn_settings_social

@onready var back: Button = $"../back"

@onready var btn_click: AudioStreamPlayer = $btn_click
@onready var btn_hover: AudioStreamPlayer = $btn_hover

@onready var settings_main: Control = $"../settings/ScrollContainer/items/settings_main"
@onready var settings_video: Control = $"../settings/ScrollContainer/items/settings_video"
@onready var settings_audio: Control = $"../settings/ScrollContainer/items/settings_audio"
@onready var settings_inputs: Control = $"../settings/ScrollContainer/items/settings_inputs"

# Vitesse d’animation
var speed := 10.0

# Échelles de base
var btn_settings_main_base_scale := Vector2(6, 6)
var btn_settings_video_base_scale := Vector2(6.5, 6.5)
var btn_settings_audio_base_scale := Vector2(4.925, 4.925)
var btn_settings_inputs_base_scale := Vector2(6.38, 6.38)
var btn_settings_network_base_scale := Vector2(6.38, 6.38)
var btn_settings_social_base_scale := Vector2(5, 5)

# Cibles d’échelle (modifiables à l’hover)
var btn_settings_main_target := btn_settings_main_base_scale
var btn_settings_video_target := btn_settings_video_base_scale
var btn_settings_audio_target := btn_settings_audio_base_scale
var btn_settings_inputs_target := btn_settings_inputs_base_scale
var btn_settings_network_target := btn_settings_network_base_scale
var btn_settings_social_target := btn_settings_social_base_scale

func _ready() -> void:
	# Appliquer les échelles initiales
	btn_settings_main.scale = btn_settings_main_base_scale
	btn_settings_video.scale = btn_settings_video_base_scale
	btn_settings_audio.scale = btn_settings_audio_base_scale
	btn_settings_inputs.scale = btn_settings_inputs_base_scale
	btn_settings_network.scale = btn_settings_network_base_scale
	btn_settings_social.scale = btn_settings_social_base_scale
	
	hide_all_section()
	settings_main.visible = true

func _process(delta: float) -> void:
	btn_settings_main.scale = btn_settings_main.scale.lerp(btn_settings_main_target, delta * speed)
	btn_settings_video.scale = btn_settings_video.scale.lerp(btn_settings_video_target, delta * speed)
	btn_settings_audio.scale = btn_settings_audio.scale.lerp(btn_settings_audio_target, delta * speed)
	btn_settings_inputs.scale = btn_settings_inputs.scale.lerp(btn_settings_inputs_target, delta * speed)
	btn_settings_network.scale = btn_settings_network.scale.lerp(btn_settings_network_target, delta * speed)
	btn_settings_social.scale = btn_settings_social.scale.lerp(btn_settings_social_target, delta * speed)

# MAIN
func _on_btn_settings_main_mouse_entered() -> void:
	btn_settings_main_target = btn_settings_main_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_main_mouse_exited() -> void:
	btn_settings_main_target = btn_settings_main_base_scale

func _on_btn_settings_main_pressed() -> void:
	btn_click.play()
	hide_all_section()
	settings_main.visible = true
	
# VIDEO
func _on_btn_settings_video_mouse_entered() -> void:
	btn_settings_video_target = btn_settings_video_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_video_mouse_exited() -> void:
	btn_settings_video_target = btn_settings_video_base_scale

func _on_btn_settings_video_pressed() -> void:
	btn_click.play()
	hide_all_section()
	settings_video.visible = true

# AUDIO
func _on_btn_settings_audio_mouse_entered() -> void:
	btn_settings_audio_target = btn_settings_audio_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_audio_mouse_exited() -> void:
	btn_settings_audio_target = btn_settings_audio_base_scale

func _on_btn_settings_audio_pressed() -> void:
	btn_click.play()
	hide_all_section()
	settings_audio.visible = true

# INPUTS
func _on_btn_settings_inputs_mouse_entered() -> void:
	btn_settings_inputs_target = btn_settings_inputs_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_inputs_mouse_exited() -> void:
	btn_settings_inputs_target = btn_settings_inputs_base_scale

func _on_btn_settings_inputs_pressed() -> void:
	btn_click.play()
	hide_all_section()
	settings_inputs.visible = true

# NETWORK
func _on_btn_settings_network_mouse_entered() -> void:
	btn_settings_network_target = btn_settings_network_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_network_mouse_exited() -> void:
	btn_settings_network_target = btn_settings_network_base_scale

func _on_btn_settings_network_pressed() -> void:
	btn_click.play()

# SOCIAL
func _on_btn_settings_social_mouse_entered() -> void:
	btn_settings_social_target = btn_settings_social_base_scale * 1.1
	btn_hover.play()

func _on_btn_settings_social_mouse_exited() -> void:
	btn_settings_social_target = btn_settings_social_base_scale

func _on_btn_settings_social_pressed() -> void:
	btn_click.play()

# Back 
func _on_back_pressed() -> void:
	if Globals.settings_location == "room":
		get_tree().change_scene_to_file("res://game/scenes/salon.tscn")

# ===========================================================================================================================
func hide_all_section():
	settings_main.visible = false
	settings_video.visible = false
	settings_audio.visible = false
	settings_inputs.visible = false
