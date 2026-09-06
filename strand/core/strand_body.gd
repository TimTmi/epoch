@abstract class_name StrandBody


@abstract func get_position() -> Vector2
@abstract func get_inverse_mass() -> float
@abstract func move(delta: Vector2) -> void


# Converts the positional corrections accumulated during the solve into motion
# the physics engine can act on (velocity). No-op for bodies that are moved
# directly (particles, plain nodes).
func commit_motion(delta_time: float) -> void:
	pass


# Drops the accumulated corrections without converting them to velocity.
func discard_motion() -> void:
	pass
