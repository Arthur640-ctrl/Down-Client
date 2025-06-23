extends CharacterBody3D

@onready var animation_tree: AnimationTree = $"visuals/mixamo_base/animation tree"

var mouvement_transition = "parameters/mouvement/transition_request"
var inMove_transition = "parameters/in_move/transition_request"
var walking_blend2d = "parameters/walking/blend_position"
var croushed_blend2d = "parameters/croushed/blend_position"
var idle_transition = "parameters/idle_type/transition_request"
var croushed_timescale = "parameters/croushed_timescale/scale"
var walking_timescale = "parameters/walking_timescale/scale"
var isjumping_transition = "parameters/is_jumping/transition_request"
var gunblend_blend2 = "parameters/gun_blend/blend_amount"

var current_blend = Vector2.ZERO  # à déclarer en tant que variable membre

func process_animations(animation_packet):
	if typeof(animation_packet) == TYPE_DICTIONARY and animation_packet.has("timescale"):
		if animation_packet["timescale"] != null:
			animation_tree[croushed_timescale] = animation_packet["timescale"]
			animation_tree[walking_timescale] = animation_packet["timescale"]

	if typeof(animation_packet) == TYPE_DICTIONARY and animation_packet.has("state") and animation_packet.has("blend_space_position"):
		var target_blend = Vector2(animation_packet["blend_space_position"][0], animation_packet["blend_space_position"][1])
		
		if current_blend != Vector2.ZERO:
			current_blend = current_blend.lerp(target_blend, Globals.DELTA * 8.0)
		else:
			current_blend = target_blend
		
		animation_tree.set(croushed_blend2d, current_blend)
		animation_tree.set(walking_blend2d, current_blend)

		if animation_packet["state"] == "in_air":
			animation_tree[isjumping_transition] = "jumping"
		else:
			animation_tree[isjumping_transition] = "on_floor"
			if animation_packet["state"] == "walking":
				animation_tree[mouvement_transition] = "walking"
				animation_tree[inMove_transition] = "moving"
			elif animation_packet["state"] == "running":
				animation_tree[mouvement_transition] = "running"
				animation_tree[inMove_transition] = "moving"
			elif animation_packet["state"] == "crouched":
				animation_tree[mouvement_transition] = "croushed"
				animation_tree[inMove_transition] = "moving"
			else:
				animation_tree[inMove_transition] = "standing"
				if animation_packet["state"] == "idle":
					animation_tree[idle_transition] = "idle"
				elif animation_packet["state"] == "idle_crouched":
					animation_tree[idle_transition] = "idle_croushed"
