extends Node

@onready var player: CharacterBody3D = $".."
@onready var raycast: RayCast3D = $"../camera_mount/camera/RayCast3D"
@onready var camera: Camera3D = $"../camera_mount/camera"
@onready var cameraMount: Node3D = $"../camera_mount"

func _ready():
	# Setup material for the grapple line
	line_material = StandardMaterial3D.new()
	line_material.albedo_color = Color(0.8, 0.8, 0.8)
	line_material.flags_unshaded = true
	line_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	line_material.vertex_color_use_as_albedo = true

func _process(delta: float) -> void:
	# Block if inventory is not available
	if Globals.inventory == null:
		return

	# Read current gadget slot
	var inventory : Dictionary = Globals.inventory
	var gadget : int = int(inventory["gadget"])
	
	# Handle input for gadget 1 (grapple)
	if gadget == 1:
		if Input.is_action_just_pressed("gadget"):
			gadget_1()
	
	# Start reload if ammo is missing
	if not isReloading and numberAmmos < maxAmmos:
		isReloading = true
		reloadTimer = 0.0

	# Process grapple + reload + rope update
	gagdet_1_process_grapple(delta)
	gagdet_1_process_recharge(delta)
	update_grapple_line()

# ===== GADGET 1 - GRAPPLE =====
# Rope reference
var grapple_line: MeshInstance3D
var line_material: StandardMaterial3D

# Grapple core vars
var isGrappling : bool = false
var grapplePoint : Vector3
var grappleMaxDistance : int = 20
var grappleSpeed : float = 15.0
var grappleFov : int = 50
var startPointNormal : float
var verticalBoost : float = 3.0

# Reload vars
var numberAmmos : int = 2
var maxAmmos : int = 2
var isReloading : bool = false
var reloadTimer : float = 0.0
var reloadCooldown : float = 3.0

func gadget_1():
	# Cancel grapple if already active
	if isGrappling:
		stop_grapple()
		return

	# Cancel if no ammo
	if numberAmmos <= 0:
		return
	
	# Perform raycast
	var ray = raycast.ray()
	
	# Validate raycast result
	if ray.has("distance") and ray["distance"] != null and ray.has("point"):
		if ray["distance"] <= grappleMaxDistance:
			# Store hit surface normal
			var normal : Vector3 = ray["normal"]
			var dot : float = normal.dot(Vector3.UP)
			startPointNormal = dot
			
			# Consume one ammo
			numberAmmos -= 1
			
			# Start grapple
			start_grapple(ray["point"])

func start_grapple(target_position: Vector3) -> void:
	# Activate grapple state
	isGrappling = true
	grapplePoint = target_position
	cameraMount.additionnalFov += 30
	create_grapple_line()

func stop_grapple() -> void:
	# Stop grapple state
	isGrappling = false
	cameraMount.additionnalFov -= 30
	remove_grapple_line()

func gagdet_1_process_grapple(delta: float) -> void:
	# Skip if grapple inactive
	if not isGrappling:
		return
	
	# Calculate direction toward grapple point
	var initalDirection : Vector3 = (grapplePoint - player.global_position).normalized()
	
	# Add vertical boost to overcome obstacles
	var verticalDirection : Vector3 = Vector3.UP * verticalBoost
	var direction : Vector3 = (initalDirection + verticalDirection).normalized()
	
	# Apply velocity to player
	player.velocity = direction * grappleSpeed
	
	# Detect surface type (ceiling/floor/wall)
	var startSurface : String = get_surface()
	
	# Stop grapple when close enough
	if player.global_position.distance_to(grapplePoint) < 1.0 and startSurface != "ceiling":
		stop_grapple()
	elif player.global_position.distance_to(grapplePoint) < 2.0:
		stop_grapple()

func gagdet_1_process_recharge(delta: float) -> void:
	# Skip if not reloading
	if not isReloading:
		return
	
	# Increase timer
	reloadTimer += delta
	
	# Add ammo when cooldown ends
	if reloadTimer >= reloadCooldown:
		numberAmmos += 1
		reloadTimer = 0.0
		
		# Keep reloading until full
		if numberAmmos < maxAmmos:
			isReloading = true
		else:
			isReloading = false

func create_grapple_line() -> void:
	# Remove old rope if it exists
	if grapple_line != null:
		remove_grapple_line()
	
	# Create a new line mesh
	grapple_line = MeshInstance3D.new()
	grapple_line.mesh = ImmediateMesh.new()
	grapple_line.material_override = line_material
	player.add_child(grapple_line)

func update_grapple_line() -> void:
	# Skip if grapple inactive or no rope
	if not isGrappling or grapple_line == null:
		return
	
	# Clear old line
	var immediate_mesh = grapple_line.mesh as ImmediateMesh
	immediate_mesh.clear_surfaces()
	
	# Draw line from player to grapple point
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(Vector3(0, 1.1, 0)) # player position
	var local_target = player.to_local(grapplePoint)       # target point
	immediate_mesh.surface_add_vertex(local_target)
	immediate_mesh.surface_end()

func remove_grapple_line() -> void:
	# Destroy rope mesh
	if grapple_line != null:
		grapple_line.queue_free()
		grapple_line = null

func get_surface() -> String:
	# Detect surface type with normal
	if startPointNormal < -0.7:
		return "ceiling"
	elif abs(startPointNormal) < 0.3:
		return "wall"
	else:
		return "floor"
