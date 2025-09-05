extends Node3D

# ==========================================================
# 📜 CAMERA_MOUNT.GD
# ----------------------------------------------------------
# 🎯 Description:
# Handles third-person shoulder camera: rotation, position,
# and dynamic FOV depending on player state (running, crouching, aiming).
# ==========================================================

# ============================
# 🔗 Node references
# ============================
@onready var ik_marker: Marker3D = $ik_marker
@onready var camera: Camera3D = $camera
@onready var player: CharacterBody3D = $".."
@onready var aiming_ik: SkeletonIK3D = $"../visuals/mixamo_base/Node/Skeleton3D/AimingIK"

# ============================
# ⚙️ External variables
# ============================
@export var sensibilityHorizontal: float = 0.05
@export var sensibilityVertical: float = 0.05
@export var bypassSettings: bool = false
@export var lerpSpeed: float = 5.0

@export var headbobFrequency : float = 2.0
@export var headbobAmplitude : float = 4.0
# ============================
# 🧠 Internal variables
# ============================

# Preset positions and FOVs based on player state
var cameraIdlePosition = Vector3(0.7, 0.152, 1.563)
var cameraIdleFov = 80

var cameraRunPosition = Vector3(0.7, 0.152, 1.563)
var cameraRunFov = 100

var cameraCrouchPosition = Vector3(0.7, -0.300, 1.563)
var cameraCrouchFov = 50

var headbobTime := 0.0
# ============================
# 🔁 Functions
# ============================

func _ready():
	# Capture mouse movement when game starts
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):

	if event is InputEventMouseMotion:
		if Globals.PREDICTION:
			# Horizontal rotation
			player.rotate_y(deg_to_rad(-event.relative.x * Globals.sens_x))

			# Vertical rotation with clamping and optional inversion
			var motionReversalMultiplier := -1 if Globals.invert_y else 1
			var newXRotation = rotation_degrees.x - event.relative.y * Globals.sens_y * motionReversalMultiplier
			newXRotation = clamp(newXRotation, -90, 90)
			rotation_degrees.x = newXRotation

		# Apply server-authoritative rotation (Multiplayer)
		if Globals.multiplayer:
			rotation_degrees = Globals.new_infos["camera_rotation"]

		# Choose between local test sensitivity and network production
		var sensibilityHorizontalSend: float = 0
		var sensibilityVerticalSend: float = 0

		if bypassSettings == true:
			sensibilityHorizontalSend = sensibilityHorizontal
			sensibilityVerticalSend = sensibilityVertical
		else:
			sensibilityHorizontalSend = Globals.sens_x
			sensibilityVerticalSend = Globals.sens_y

		# Store the mouse event for server communication (Multiplayer)
		Globals.EVENT_MOUSE = {
			"relative": [event.relative.x, event.relative.y],
			"sens_horizontal": sensibilityHorizontalSend,
			"sens_vertical": sensibilityVerticalSend
		}

func _process(delta: float) -> void:
	# Activate this camera if it's set as the current one
	camera.current = Globals.PLAYER_CAM_CURRENT

	# Handle aiming IK activation
	if Globals.inventory != null:
		if Globals.inventory != null and Globals.actual_slot != null:
			if Globals.inventory["active"][int(Globals.actual_slot)]["item"] != null:
				if Input.is_action_pressed("aiming"):
					Globals.IS_AIMING = true
					aiming_ik.start()
				else:
					Globals.IS_AIMING = false
					await get_tree().create_timer(0.1).timeout
					aiming_ik.stop()

	# Determine target position and FOV
	var targetPosition = cameraIdlePosition
	var targetFov = cameraIdleFov

	if Globals.IS_RUNNING and Globals.stamina > Globals.STAMINA_THRESHOLD and player.inputDirection == Vector2(0, -1):
		targetPosition = cameraRunPosition
		targetFov = cameraRunFov
	elif Globals.IS_CROUSHED:
		targetPosition = cameraCrouchPosition
		targetFov = cameraCrouchFov

	# Smoothly interpolate camera position and FOV
	camera.position = camera.position.lerp(targetPosition, delta * lerpSpeed)
	camera.fov = lerp(camera.fov, float(targetFov), delta * lerpSpeed)
	
	# Set the headbobAmplitude and the headbobFrequency depending of the state of the player
	if player.is_running and Globals.stamina > Globals.STAMINA_THRESHOLD:
		headbobAmplitude = 0.003
		headbobFrequency = 5.0
	else:
		headbobAmplitude = 0.0015
		headbobFrequency = 5.0
	
	# Calculate and set the headbob
	headbobTime += delta * player.velocity.length() * float(player.is_on_floor())
	
	if player.velocity.length() > 0.1 and player.is_on_floor() and Globals.stamina > 0:
		camera.position += headbob(headbobTime)

func headbob(headbobTimeLocal):
	var headbobPosition = Vector3.ZERO
	headbobPosition.y = sin(headbobTimeLocal * headbobFrequency) * headbobAmplitude
	headbobPosition.z = cos(headbobTimeLocal * headbobFrequency / 2) * headbobAmplitude
	return headbobPosition
