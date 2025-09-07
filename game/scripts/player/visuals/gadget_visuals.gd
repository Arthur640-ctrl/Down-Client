extends Node

@onready var player: CharacterBody3D = $".."
@onready var raycast: RayCast3D = $"../camera_mount/camera/RayCast3D"
@onready var camera: Camera3D = $"../camera_mount/camera"
@onready var cameraMount: Node3D = $"../camera_mount"

# Référence pour la ligne visuelle
var grapple_line: MeshInstance3D
var line_material: StandardMaterial3D

func _ready():
	# Préparer le matériau pour la ligne
	line_material = StandardMaterial3D.new()
	line_material.albedo_color = Color(0.8, 0.8, 0.8)
	line_material.flags_unshaded = true
	line_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	line_material.vertex_color_use_as_albedo = true

func _process(delta: float) -> void:
	if Globals.inventory == null:
		return

	var inventory : Dictionary = Globals.inventory
	var gadget : int = int(inventory["gadget"])
	
	if gadget == 1:
		if Input.is_action_just_pressed("gadget"):
			gadget_1()
	
	# === Other : ===
	# 1 :
	if not isReloading and currentCharge < maxCharges:
		isReloading = true
		rechargeTimer = 0.0

	gagdet_1_process_grapple(delta)
	gagdet_1_process_recharge(delta)
	update_grapple_line()

# ===== GADGET 1 - GRAPPIN =====
var isGrappling : bool = false
var currentCharge : int = 2
var grappleMaxDistance : int = 20
var grapplePoint : Vector3
var grappleSpeed : float = 15.0
var isReloading : bool = false
var rechargeTimer : float = 0.0
var rechargeCooldown : float = 3.0
var maxCharges : int = 2
var grappleFov : int = 50

func gadget_1():
	if isGrappling:
		stop_grapple()
		return

	if currentCharge <= 0:
		return
	
	var ray = raycast.ray()
	
	if ray.has("distance") and ray["distance"] != null and ray.has("point"):
		if ray["distance"] <= grappleMaxDistance:
			currentCharge -= 1
			start_grapple(ray["point"])

func start_grapple(target_position: Vector3) -> void:
	isGrappling = true
	grapplePoint = target_position
	cameraMount.additionnalFov += 30
	create_grapple_line()

func stop_grapple() -> void:
	isGrappling = false
	cameraMount.additionnalFov -= 30
	remove_grapple_line()

func gagdet_1_process_grapple(delta: float) -> void:
	if not isGrappling:
		return
	
	# Calculer la direction vers le point de grappin
	var direction = (grapplePoint - player.global_position).normalized()
	
	# Ajouter une composante verticale pour passer au-dessus des obstacles
	var vertical_boost = Vector3.UP * 0.3
	var final_direction = (direction + vertical_boost).normalized()
	
	# Appliquer la vélocité
	player.velocity = final_direction * grappleSpeed
	player.move_and_slide()
	
	# Vérifier si on est arrivé proche du point
	if player.global_position.distance_to(grapplePoint) < 1.5:
		stop_grapple()

func gagdet_1_process_recharge(delta: float) -> void:
	if not isReloading:
		return
	
	rechargeTimer += delta
	
	if rechargeTimer >= rechargeCooldown:
		currentCharge += 1
		rechargeTimer = 0.0
		
		if currentCharge < maxCharges:
			isReloading = true
		else:
			isReloading = false

func create_grapple_line() -> void:
	if grapple_line != null:
		remove_grapple_line()
	
	# Créer un nouveau MeshInstance3D pour la ligne
	grapple_line = MeshInstance3D.new()
	grapple_line.mesh = ImmediateMesh.new()
	grapple_line.material_override = line_material
	player.add_child(grapple_line)

func update_grapple_line() -> void:
	if not isGrappling or grapple_line == null:
		return
	
	var immediate_mesh = grapple_line.mesh as ImmediateMesh
	immediate_mesh.clear_surfaces()
	
	# Dessiner la ligne entre le joueur et le point de grappin
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# Point de départ (position locale du joueur)
	immediate_mesh.surface_add_vertex(Vector3(0, 1.1, 0))
	
	# Point d'arrivée (converti en coordonnées locales)
	var local_target = player.to_local(grapplePoint)
	immediate_mesh.surface_add_vertex(local_target)
	
	immediate_mesh.surface_end()

func remove_grapple_line() -> void:
	if grapple_line != null:
		grapple_line.queue_free()
		grapple_line = null
