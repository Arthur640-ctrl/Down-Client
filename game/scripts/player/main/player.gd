extends CharacterBody3D

# ==========================================================
# 📜 PLAYER.GD
# ----------------------------------------------------------
# 🎯 Description:
# Allows you to manage player inputs, client prediction, 
# animations
# ==========================================================

# ============================
# 🔗 Node references
# ============================
@onready var cameraMount: Node3D = $camera_mount
@onready var player_animations: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var animation_tree: AnimationTree = $"visuals/mixamo_base/animation tree"
@onready var raycast: RayCast3D = $raycast
@onready var floor_detection: RayCast3D = $detection/down/floor_detection
@onready var detection: Node3D = $detection
@onready var ui_game: Control = $UI_GAME

# ============================
# ⚙️ External variables
# ============================
@export var useLocalSettings : bool = false
@export var maintainForCroushed : bool = false
@export var maintainForAiming : bool = false

# ============================
# 🧠 Internal variables
# ============================
var SPEED : float = 3
var JUMP_VELOCITY : float = 4.5
var GRAVITY : float = -9.8

var WALKING_SPEED : float = 3  
var RUNNING_SPEED : float = 5
var CROUSHED_SPEED : float = 1.5

var inputDirection = null
var direction = null
var blend_space_vector = null

var current_hand = null

var is_running : bool = false
var is_croushed : bool = false
var is_jumping : bool = false
var is_aiming : bool = false
var is_shooting : bool = false
var is_reloading : bool = false
var is_use_gadget : bool = false

var alreday_land : bool = false

var mouvement_transition : String = "parameters/mouvement/transition_request"
var inMove_transition : String = "parameters/in_move/transition_request"
var walking_blend2d : String = "parameters/walking/blend_position"
var croushed_blend2d : String = "parameters/crouched/blend_position"
var idle_transition : String = "parameters/idle_type/transition_request"
var croushed_timescale : String = "parameters/croushed_timescale/scale"
var walking_timescale : String = "parameters/walking_timescale/scale"
var isjumping_transition : String = "parameters/is_jumping/transition_request"
var gunblend_blend2 : String = "parameters/gun_blend/blend_amount"

var walking_blend_position : Vector2 = Vector2.ZERO
var crouched_blend_position : Vector2 = Vector2.ZERO

var current_gun_blend : float = 1.0

var blend_smooth : float = 8.0

var items : Dictionary = {
	100001: {
		"type": "weapon",
	}
}

# ============================
# 🔁 Functions
# ============================
func _ready() -> void:
	# Active the animation tree and load local config (test) or player config (prod)
	animation_tree.active = true
	
	if useLocalSettings != true:
		maintainForCroushed = str_to_bool(Globals.settings["inputs"]["maintain_for_croushed"])
		maintainForAiming = str_to_bool(Globals.settings["inputs"]["maintain_for_aiming"])

func transformInput(inputDirectionToTransform : Vector2):
	# Return Vector2 for the blend and ajust the timescale of animations
	if inputDirectionToTransform.is_equal_approx(Vector2(0, -1)): # Forward
		return Vector2(0, 1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(0, 1)): # Backward
		return Vector2(0, -1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(-1, 0)): # Left
		return Vector2(-1, 0)

	elif inputDirectionToTransform.is_equal_approx(Vector2(1, 0)): # Right
		return Vector2(1, 0)

	elif inputDirectionToTransform.is_equal_approx(Vector2(-0.707107, -0.707107)): # Forward Left
		return Vector2(-1, 1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(0.707107, -0.707107)): # Forward Right
		return Vector2(1, 1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(0.707107, 0.707107)): # Backward Right
		return Vector2(1, -1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(-0.707107, 0.707107)): # Backward Left
		return Vector2(-1, -1)

	elif inputDirectionToTransform.is_equal_approx(Vector2(0, 0)):
		return Vector2(0, 0)

	else:
		return Vector2(0, 0)

func get_inputs():
	is_running = Input.is_action_pressed("run")
	
	is_shooting = Input.is_action_pressed("use")
	
	is_reloading = Input.is_action_pressed("reload")
	
	is_use_gadget = Input.is_action_pressed("gadget")
	
	if maintainForCroushed:
		if Input.is_action_just_pressed("crouched"):
			if is_croushed == true:
				is_croushed = false
			else:
				is_croushed = true
	else:
		if Input.is_action_pressed("crouched"):
			is_croushed = true
		else:
			is_croushed = false
			
	# Aiming :
	if current_hand != null:
		if maintainForAiming:
			if Input.is_action_just_pressed("aiming"):
				if is_aiming == true:
					is_aiming = false
				else:
					is_aiming = true
		else:
			if Input.is_action_pressed("aiming"):
				is_aiming = true
			else:
				is_aiming = false 
				
	# Update :
	Globals.IS_CROUSHED = is_croushed
	Globals.IS_RUNNING = is_running
	Globals.IS_JUMPING = Input.is_action_pressed("jump")
	Globals.IS_SHOOTING = is_shooting
	Globals.INV_UP = Input.is_action_just_pressed("inventory_up")
	Globals.INV_DOWN = Input.is_action_just_pressed("inventory_down")
	Globals.IS_INTERACT = Input.is_action_pressed("interact")
	Globals.IS_AIMING = is_aiming
	Globals.IS_RELOADING = is_reloading
	Globals.IS_USE_GADGET = is_use_gadget

func _physics_process(delta: float) -> void:
	var t = time_to_land()
	# - Set to Globals
	Globals.DELTA = delta
	Globals.INPUT_DIR = inputDirection
	Globals.IS_JUMPING = is_jumping
	position = Globals.new_infos["position"]
	rotation_degrees = Globals.new_infos["rotation"]
		
	# - Get all infos
	maintainForCroushed = str_to_bool(Globals.settings["inputs"]["maintain_for_croushed"])
	maintainForAiming = str_to_bool(Globals.settings["inputs"]["maintain_for_aiming"])
	
	
	get_inputs()

	if Input.is_action_just_pressed("ui_accept"):
		is_jumping = true
	else:
		is_jumping = false
	
	inputDirection = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	blend_space_vector = transformInput(inputDirection)

	var current_blend = animation_tree[gunblend_blend2]
	var target_blend = current_gun_blend
	var blend_speed = 7.0

	animation_tree[gunblend_blend2] = lerp(current_blend, target_blend, blend_speed * delta)

	# - Only if there are prediction (essential else the player don't work)
	# Mouvements
	if Globals.PREDICTION:
		# print(Globals.blocked)
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Globals.stamina > 0:
			velocity.y = JUMP_VELOCITY
			is_jumping = true
		else:
			is_jumping = false
		
		if is_on_floor():
			if !Globals.blocked:
				animation_tree[isjumping_transition] = "on_floor"
				$stairs.disabled = false
				alreday_land = false
				
		else:
			velocity += get_gravity() * delta
			$stairs.disabled = true
			
			if Globals.stamina > 10:
				animation_tree[isjumping_transition] = "jumping"
			
			# TEST
			
			if !is_on_floor() and t <= 0.5 and !alreday_land and velocity.y < 0:
				animation_tree["parameters/land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
				alreday_land = true
			
		if direction and !Globals.blocked:
			animation_tree[inMove_transition] = "moving"
				
			if is_running:
				if inputDirection.y > 0 or inputDirection.x > 0 or inputDirection.x < 0:
					SPEED = WALKING_SPEED
					animation_tree[mouvement_transition] = "walking"
					animation_tree.set(walking_blend2d, blend_space_vector)
				else:
					SPEED = RUNNING_SPEED

					if Globals.stamina > Globals.STAMINA_THRESHOLD:
						animation_tree[mouvement_transition] = "running"
					else:
						animation_tree[mouvement_transition] = "walking"
						animation_tree.set(walking_blend2d, blend_space_vector)

			elif is_croushed:
				SPEED = CROUSHED_SPEED
				animation_tree[mouvement_transition] = "croushed"
				crouched_blend_position = crouched_blend_position.lerp(blend_space_vector, delta * blend_smooth)
				animation_tree.set(croushed_blend2d, crouched_blend_position)

			else:
				SPEED = WALKING_SPEED
				animation_tree[mouvement_transition] = "walking"
				walking_blend_position = walking_blend_position.lerp(blend_space_vector, delta * blend_smooth)
				animation_tree.set(walking_blend2d, walking_blend_position)

			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if is_croushed:
				animation_tree[inMove_transition] = "standing"
				animation_tree[idle_transition] = "idle_croushed"
			else:
				animation_tree[idle_transition] = "idle"
				animation_tree[inMove_transition] = "standing"
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	# Mvt and slide
	if Globals.PREDICTION and !Globals.blocked:
		move_and_slide()


func update_stamina(value):
	ui_game.update_stamina(value)

func update_health(value):
	ui_game.update_health(value)

func str_to_bool(value: String) -> bool:
	var normalized = value.strip_edges().to_lower()
	return normalized in ["true", "1", "yes", "on"]
	
func time_to_land() -> float:
	# Retourne le temps estimé avant de toucher le sol.
	if is_on_floor():
		return 0.0

	# initialisation sûre
	var dist: float = INF

	# 1) essaye le RayCast 'floor_detection' s'il est dispo et colliding
	if floor_detection and floor_detection.is_enabled() and floor_detection.is_colliding():
		var hit_pos: Vector3 = floor_detection.get_collision_point()
		dist = global_transform.origin.y - hit_pos.y
		if dist <= 0.001:
			return 0.0
	else:
		# 2) fallback : intersect_ray
		var from = global_transform.origin
		var to = from + Vector3.DOWN * 100.0
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if not result:
			return INF
		dist = from.y - result.position.y
		if dist <= 0.001:
			return 0.0

	# maintenant dist est bien défini (ou INF si pas trouvé)
	if dist == INF:
		return INF

	# paramètres physiques
	var g = float(ProjectSettings.get_setting("physics/3d/default_gravity")) # >0
	var v = velocity.y # vy (positif = vers le haut)

	# discriminant : v^2 + 2*g*dist
	var discr = v * v + 2.0 * g * dist
	if discr < 0.0:
		return INF

	var t = (v + sqrt(discr)) / g
	if t <= 0.0:
		return INF

	# debug utile :
	# print("t:", t, " dist:", dist, " vy:", v, " on floor:", is_on_floor(), " alreday_land:", alreday_land)

	return t
