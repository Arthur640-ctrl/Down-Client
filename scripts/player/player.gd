extends CharacterBody3D
@onready var anim_tree: AnimationTree = $visuals/mixamo_base/walking

# =============
@onready var camera_mount: Node3D = $camera_mount
@onready var player_animations: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var animation_tree: AnimationTree = $"visuals/mixamo_base/animation tree"
@onready var raycast: RayCast3D = $raycast
@onready var floor_detection: RayCast3D = $detection/down/floor_detection
@onready var detection: Node3D = $detection
@onready var ui_game: Control = $UI_GAME
# =============
var SPEED = 3
var JUMP_VELOCITY = 4.5
var GRAVITY = -9.8

var WALKING_SPEED = 3  
var RUNNING_SPEED = 5
var CROUSHED_SPEED = 1.5

var input_dir = null
var direction = null
var blend_space_vector = null
# =============
var current_hand = null
# =============
var is_running = false
var is_croushed = false
var is_jumping = false
var is_aiming = false
var is_shooting = false
@export var maintain_for_croushed = false
@export var maintain_for_aiming = false
var mvt_block = false
var have_gun = true
# =============
var mouvement_transition = "parameters/mouvement/transition_request"
var inMove_transition = "parameters/in_move/transition_request"
var walking_blend2d = "parameters/walking/blend_position"
var croushed_blend2d = "parameters/croushed/blend_position"
var idle_transition = "parameters/idle_type/transition_request"
var croushed_timescale = "parameters/croushed_timescale/scale"
var walking_timescale = "parameters/walking_timescale/scale"
var isjumping_transition = "parameters/is_jumping/transition_request"
var gunblend_blend2 = "parameters/gun_blend/blend_amount"
var gunState_transition = "parameters/gun_state/transition_request"
var fireGenericRifle = "parameters/fire_genericRifle/request"

var walking_blend_position := Vector2.ZERO
var crouched_blend_position := Vector2.ZERO

var current_gun_blend := 1.0

var blend_smooth = 8.0
# =============
func _ready() -> void:
	animation_tree.active = true

func transform_input(input_dir):
	if input_dir.is_equal_approx(Vector2(0, -1)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(0, 1)
	elif input_dir.is_equal_approx(Vector2(0, 1)):
		animation_tree[croushed_timescale] = -1
		animation_tree[walking_timescale] = -1
		return Vector2(0, 1)
	elif input_dir.is_equal_approx(Vector2(-1, 0)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(-1, 0)
	elif input_dir.is_equal_approx(Vector2(1, 0)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(1, 0)
		
	elif input_dir.is_equal_approx(Vector2(-0.707107, -0.707107)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(-0.5, 0.5)
	elif input_dir.is_equal_approx(Vector2(0.707107, -0.707107)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(0.5, 0.5)
		
	elif input_dir.is_equal_approx(Vector2(0.707107, 0.707107)):
		animation_tree[croushed_timescale] = -1
		animation_tree[walking_timescale] = -1
		return Vector2(-0.5, 0.5)
	elif input_dir.is_equal_approx(Vector2(-0.707107, 0.707107)):
		animation_tree[croushed_timescale] = -1
		animation_tree[walking_timescale] = -1
		return Vector2(0.5, 0.5)
		
	elif input_dir.is_equal_approx(Vector2(0, 0)):
		animation_tree[croushed_timescale] = 1
		animation_tree[walking_timescale] = 1
		return Vector2(0, 0)

func get_inputs():
	# Running :
	is_running = Input.is_action_pressed("run")
	
	is_shooting = Input.is_action_pressed("fire")
	
	# Croushed :
	if maintain_for_croushed:
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
		if maintain_for_aiming:
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
	Globals.IS_JUMPING = is_jumping
	Globals.IS_SHOOTING = is_shooting
	Globals.INV_UP = Input.is_action_just_pressed("inventory_up")
	Globals.INV_DOWN = Input.is_action_just_pressed("inventory_down")

func _physics_process(delta: float) -> void:
	# - Set to Globals
	Globals.DELTA = delta
	if Globals.MULTIPLAYER:
		Globals.INPUT_DIR = input_dir
		Globals.IS_JUMPING = is_jumping
		position = Globals.new_infos["position"]
		rotation_degrees = Globals.new_infos["rotation"]
		
	# - Get all infos
	maintain_for_croushed = Globals.settings["inputs"]["maintain_for_croushed"]
	maintain_for_aiming = Globals.settings["inputs"]["maintain_for_aiming"]
	
	get_inputs()
	
	if Input.is_action_just_pressed("ui_accept"):
		is_jumping = true
	else:
		is_jumping = false
	
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	blend_space_vector = transform_input(input_dir)
	

	animation_tree[gunblend_blend2] = current_gun_blend

	# - Only if there are prediction (essential else the player don't work)
	# Mouvements
	if Globals.PREDICTION:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Globals.stamina > 0:
			velocity.y = JUMP_VELOCITY
			is_jumping = true
		else:
			is_jumping = false
		
		if is_on_floor():
			animation_tree[isjumping_transition] = "on_floor"
			$stairs.disabled = false
		else:
			if !is_on_floor():
				animation_tree[isjumping_transition] = "jumping"
			velocity += get_gravity() * delta
			$stairs.disabled = true
			
		if direction:
			animation_tree[inMove_transition] = "moving"
				
			if is_running:
				if input_dir.y > 0 or input_dir.x > 0 or input_dir.x < 0:
					SPEED = WALKING_SPEED
					animation_tree[mouvement_transition] = "walking"
					animation_tree.set(walking_blend2d, blend_space_vector)
				else:
					SPEED = RUNNING_SPEED
					if Globals.stamina > 0:
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
		
		if is_aiming:
			animation_tree["parameters/gun_state/transition_request"] = "aiming"
		else:
			animation_tree["parameters/gun_state/transition_request"] = "idle"
	
	# Mvt and slide
	if Globals.PREDICTION:
		move_and_slide()
	
	# Other animations
	if Globals.PREDICTION and have_gun:
		if Input.is_action_pressed("aiming"):
			animation_tree[gunState_transition] = "aiming"
		else:
			animation_tree[gunState_transition] = "idle"
			
		if Input.is_action_pressed("fire"):
			animation_tree["parameters/fire_genericRifle/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		



func update_stamina(value):
	ui_game.update_stamina(value)
	
func update_health(value):
	ui_game.update_health(value)
