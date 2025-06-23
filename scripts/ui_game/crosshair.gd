extends CenterContainer

# ===== PARAMS =====
@onready var UI_GAME: Control = $".."
# ==================
func _draw() -> void:
	draw_circle(Vector2(0, 0), UI_GAME.DOT_RADIUS, UI_GAME.DOT_COLOR)


#	UI_GAME.RETICLE_LINES[0].position = lerpf(UI_GAME.RETICLE_LINES[0].position, pos + Vector2(0, -speed * UI_GAME.RETICLE_DISTANCE), UI_GAME.RETICLE_SPEED) # Top
#	UI_GAME.RETICLE_LINES[1].position = lerpf(UI_GAME.RETICLE_LINES[0].position, pos + Vector2(speed * UI_GAME.RETICLE_DISTANCE, 0), UI_GAME.RETICLE_SPEED) # Right
#	UI_GAME.RETICLE_LINES[2].position = lerpf(UI_GAME.RETICLE_LINES[0].position, pos + Vector2(0, speed * UI_GAME.RETICLE_DISTANCE), UI_GAME.RETICLE_SPEED) # Left
#	UI_GAME.RETICLE_LINES[3].position = lerpf(UI_GAME.RETICLE_LINES[0].position, pos + Vector2(speed * UI_GAME.RETICLE_DISTANCE, 0), UI_GAME.RETICLE_SPEED) # Bottom
