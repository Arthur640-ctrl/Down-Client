extends CenterContainer

# ===== PARAMS =====
@onready var UI_GAME: Control = $".."  # ton Control principal
@onready var player: CharacterBody3D = $"../.."

# ==================
func _draw() -> void:
	draw_circle(Vector2(0, 0), UI_GAME.DOT_RADIUS, UI_GAME.DOT_COLOR)

func _process(delta: float) -> void:
	var horizontalVelocity = Vector3(player.velocity.x, 0, player.velocity.z)
	var speed = horizontalVelocity.length()

	var center = Vector2(0, 0)  # position centrale du crosshair

	# Top
	UI_GAME.RETICLE_LINES[0].position = lerp(
		UI_GAME.RETICLE_LINES[0].position,
		center + Vector2(0, -speed * UI_GAME.RETICLE_DISTANCE),
		UI_GAME.RETICLE_SPEED
	)

	# Right
	UI_GAME.RETICLE_LINES[1].position = lerp(
		UI_GAME.RETICLE_LINES[1].position,
		center + Vector2(speed * UI_GAME.RETICLE_DISTANCE, 0),
		UI_GAME.RETICLE_SPEED
	)

	# Bottom
	UI_GAME.RETICLE_LINES[2].position = lerp(
		UI_GAME.RETICLE_LINES[2].position,
		center + Vector2(0, speed * UI_GAME.RETICLE_DISTANCE),
		UI_GAME.RETICLE_SPEED
	)

	# Left
	UI_GAME.RETICLE_LINES[3].position = lerp(
		UI_GAME.RETICLE_LINES[3].position,
		center + Vector2(-speed * UI_GAME.RETICLE_DISTANCE, 0),
		UI_GAME.RETICLE_SPEED
	)
