extends RayCast3D

# ==========================================================
# 📜 RAYCAST.GD
# ----------------------------------------------------------
# 🎯 Description:
# Utility function to detect a target with a raycast,
# optionally constrained by a maximum reach distance.
# Includes optional debug output.
# ==========================================================

# ============================
# 🔁 Functions
# ============================
func detect_raycast(maximumReach: float, debugging: bool = false, maximumReachEnabled: bool = false):
	# Check if the raycast is currently colliding with something
	if is_colliding():
		var collision_point = get_collision_point()
		var origin = global_transform.origin
		var distance = origin.distance_to(collision_point)

		# If max reach is enabled, check distance against it
		if maximumReachEnabled:
			if distance <= maximumReach:
				var target = get_collider()
				if debugging:
					print("🎯 Target detected at", distance, "units:", target.name)
				return target
			else:
				if debugging:
					print("⚠ Target too far:", distance, "units")
		else:
			var target = get_collider()
			if debugging:
				print("🎯 Target detected without range limit:", target.name)
			return target

	# No collision or target not valid
	return null
