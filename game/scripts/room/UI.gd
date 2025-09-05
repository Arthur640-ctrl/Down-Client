extends CanvasLayer

# Boutons
@onready var game_btn: TextureButton = $Main/header_base/game_btn
@onready var home_btn: TextureButton = $Main/header_base/home_btn
@onready var shop_btn: TextureButton = $Main/header_base/shop_btn
@onready var settings_btn: TextureButton = $Main/header_base/settings_btn
@onready var style_btn: TextureRect = $Main/btn_style
@onready var btn_style_logo: TextureButton = $Main/btn_style/btn_style_logo
@onready var btn_joueur_sound: AudioStreamPlayer = $Main/gamemode_and_play/btn_jouer/btn_joueur_sound
@onready var btn_header_click: AudioStreamPlayer = $Main/header_base/btn_click
@onready var btn_header_hover: AudioStreamPlayer = $Main/header_base/btn_hover

# Anim tree 
@onready var player_animation_tree: AnimationTree = $"../visuals/mixamo_base/AnimationTree"

# Échelles
var base_scale := Vector2(0.8, 0.8)
var hover_scale := Vector2(1.0, 1.0)
var speed := 10.0

# Cibles
var home_btn_target_scale := base_scale
var game_btn_target_scale := base_scale
var shop_btn_target_scale := base_scale
var settings_btn_target_scale := base_scale
var style_btn_target_scale := base_scale

func _ready() -> void:
	# Appliquer l’échelle de base dès le début
	home_btn.scale = base_scale
	game_btn.scale = base_scale
	shop_btn.scale = base_scale
	settings_btn.scale = base_scale
	btn_style_logo.scale = Vector2(1.4, 1.4)

	player_animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _process(delta: float) -> void:
	if home_btn:
		home_btn.scale = home_btn.scale.lerp(home_btn_target_scale, delta * speed)
	if game_btn:
		game_btn.scale = game_btn.scale.lerp(game_btn_target_scale, delta * speed)
	if shop_btn:
		shop_btn.scale = shop_btn.scale.lerp(shop_btn_target_scale, delta * speed)
	if settings_btn:
		settings_btn.scale = settings_btn.scale.lerp(settings_btn_target_scale, delta * speed)
	if style_btn:
		btn_style_logo.scale = btn_style_logo.scale.lerp(style_btn_target_scale, delta * speed)

# HOME
func _on_home_btn_mouse_entered() -> void:
	home_btn_target_scale = hover_scale
	btn_header_hover.play()

func _on_home_btn_mouse_exited() -> void:
	home_btn_target_scale = base_scale

func _on_home_btn_pressed() -> void:
	btn_header_click.play()

# GAME
func _on_game_btn_mouse_entered() -> void:
	game_btn_target_scale = hover_scale
	btn_header_hover.play()

func _on_game_btn_mouse_exited() -> void:
	game_btn_target_scale = base_scale

func _on_game_btn_pressed() -> void:
	btn_header_click.play()

# SHOP
func _on_shop_btn_mouse_entered() -> void:
	shop_btn_target_scale = hover_scale
	btn_header_hover.play()

func _on_shop_btn_mouse_exited() -> void:
	shop_btn_target_scale = base_scale

func _on_shop_btn_pressed() -> void:
	btn_header_click.play()

# SETTINGS
func _on_settings_btn_mouse_entered() -> void:
	settings_btn_target_scale = hover_scale
	btn_header_hover.play()

func _on_settings_btn_mouse_exited() -> void:
	settings_btn_target_scale = base_scale

func _on_settings_btn_pressed() -> void:
	btn_header_click.play()
	Globals.settings_location = "room"
	get_tree().change_scene_to_file("res://game/scenes/settings.tscn")

# STYLE
func _on_btn_style_mouse_entered() -> void:
	style_btn_target_scale = Vector2(1.4, 1.4)

func _on_btn_style_mouse_exited() -> void:
	style_btn_target_scale = base_scale

# OTHER
func _on_btn_jouer_pressed() -> void:
	player_animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	btn_joueur_sound.play()
