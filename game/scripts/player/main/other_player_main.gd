extends CharacterBody3D

@onready var animation_tree: AnimationTree = $"visuals/mixamo_base/animation tree"
@onready var weapon_pivot: Node3D = $visuals/mixamo_base/Node/Skeleton3D/weapon/weapon_pivot

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

var current_blend = Vector2.ZERO  # à déclarer en tant que variable membre
var shooting_in_progress = false


func process_animations(animation_packet):
	
	if typeof(animation_packet) == TYPE_DICTIONARY and animation_packet.has("timescale"):
		if animation_packet["timescale"] != null:
			animation_tree[croushed_timescale] = animation_packet["timescale"]
			animation_tree[walking_timescale] = animation_packet["timescale"]

	if typeof(animation_packet) == TYPE_DICTIONARY and animation_packet.has("state") and animation_packet.has("blend_space_position") and animation_packet.has("have_gun"):
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
		
		var gun_blend_target = 1.0 if animation_packet["have_gun"] else 0.0
		var gun_blend_current = float(animation_tree[gunblend_blend2])
		animation_tree[gunblend_blend2] = lerp(gun_blend_current, gun_blend_target, Globals.DELTA * 2.0)
		
		if animation_packet["aiming"] == false:
			$visuals/mixamo_base/Node/Skeleton3D/SkeletonIK3D.stop()
			animation_tree[gunState_transition] = "idle"
		else:
			$visuals/mixamo_base/Node/Skeleton3D/SkeletonIK3D.start()
			animation_tree[gunState_transition] = "aiming"
			

		weapon_pivot.maj_shooting(animation_packet["shooting"])

func process_weaponpivot(slot, inv):
	$visuals/mixamo_base/Node/Skeleton3D/weapon/weapon_pivot.process_weapon_pivot(slot, inv)
