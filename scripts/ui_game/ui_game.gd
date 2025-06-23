extends Control

# ===== POINT =====
@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOR : Color = Color.WHITE
# ===== LINES =====
@export var RETICLE_LINES : Array[Line2D]
@export var RETICLE_SPEED : float = 0.25
@export var RETICLE_DISTANCE : float = 2.0
@export var PLAYER_CONTROLLER : CharacterBody3D
# =================
@onready var crosshair_center_container: CenterContainer = $Crosshair
# =================
@onready var stamina_bar: ProgressBar = $"../UI_GAME/stamina_bar"
@onready var health_bar: ProgressBar = $"../UI_GAME/health_bar"
# =================

func update_stamina(value):
	stamina_bar.value = value
	
func update_health(value):
	health_bar.value = value
