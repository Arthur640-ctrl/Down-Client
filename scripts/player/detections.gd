extends Node3D

# ============ RayCasts
# Top :
@onready var top_forward: RayCast3D = $top/forward
@onready var top_left: RayCast3D = $top/left
@onready var top_right: RayCast3D = $top/right
@onready var top_backward: RayCast3D = $top/backward
# Down :
@onready var down_forward: RayCast3D = $down/forward
@onready var down_left: RayCast3D = $down/left
@onready var down_right: RayCast3D = $down/right
@onready var down_backward: RayCast3D = $down/backward
# Other :
@onready var floor_detection: RayCast3D = $down/floor_detection
# ============
@onready var detection_top_position: BoneAttachment3D = $"../visuals/mixamo_base/Node/Skeleton3D/detection_top_position"
@onready var top: Node3D = $top
# ============

# Résultats de distances
var distance_top_forward = 0.0
var distance_top_backward = 0.0
var distance_top_right = 0.0
var distance_top_left = 0.0

var distance_down_forward = 0.0
var distance_down_backward = 0.0
var distance_down_right = 0.0
var distance_down_left = 0.0

# Résumé Vector4 (forward, right, backward, left)
var top_distance = Vector4.ZERO
var down_distance = Vector4.ZERO

var detection_state = {
	"top": {
		"forward": 0,
		"backward": 0,
		"right": 0,
		"left": 0
	},
	"down": {
		"wall_detection": false,
		"backward": 0,
		"right": 0,
		"left": 0
	},
	"floor_detection": false,
	"against_wall": false,
	"floor_y": 0
}
# ============ Fonction utilitaire
func get_distance_from_ray(ray: RayCast3D) -> float:
	if ray.is_colliding():
		var origin = ray.global_transform.origin
		var point = ray.get_collision_point()
		return origin.distance_to(point)
	return 0.0

# ============ Main loop
func _process(delta: float) -> void:
	top.position.y = detection_top_position.position.y / 100.0

	# Top
	distance_top_forward = get_distance_from_ray(top_forward)
	distance_top_right = get_distance_from_ray(top_right)
	distance_top_backward = get_distance_from_ray(top_backward)
	distance_top_left = get_distance_from_ray(top_left)
	
	# Down
	distance_down_forward = get_distance_from_ray(down_forward)
	distance_down_right = get_distance_from_ray(down_right)
	distance_down_backward = get_distance_from_ray(down_backward)
	distance_down_left = get_distance_from_ray(down_left)

	# Mise à jour des Vector4
	top_distance = Vector4(distance_top_forward, distance_top_right, distance_top_backward, distance_top_left)
	down_distance = Vector4(distance_down_forward, distance_down_right, distance_down_backward, distance_down_left)

	# Mise à jour du dictionnaire detection_state
	detection_state["top"]["forward"] = distance_top_forward
	detection_state["top"]["right"] = distance_top_right
	detection_state["top"]["backward"] = distance_top_backward
	detection_state["top"]["left"] = distance_top_left

	detection_state["down"]["forward"] = distance_down_forward
	detection_state["down"]["right"] = distance_down_right
	detection_state["down"]["backward"] = distance_down_backward
	detection_state["down"]["left"] = distance_down_left

	# Optionnel : détecter si un mur est proche en dessous (ex : moins de 1 unité)
	detection_state["down"]["wall_detection"] = distance_down_forward
	
	# Debug print
	# print("Top distances  : ", top_distance)
	# print("Down distances : ", down_distance)
	# print(detection_state)
	# print(floor_detection.is_colliding())
	
	# print(distance_down_forward)
	
	if down_forward.is_colliding() and distance_down_forward < 0.7:
		detection_state["against_wall"] = true
	else:
		detection_state["against_wall"] = false

		
	if floor_detection.is_colliding():
		var collision_point = floor_detection.get_collision_point()
		detection_state["floor_detection"] = true
		detection_state["floor_y"] = collision_point.y
	else:
		detection_state["floor_detection"] = false
		detection_state["floor_y"] = null

	Globals.DETECTION_STATE = detection_state
