class_name Projectile extends RigidBody2D


func setup_physics(physics_profile: PhysicsProfile) -> void:
	self.collision_layer = physics_profile.projectile_layer
	self.collision_mask = physics_profile.projectile_mask

func face(direction: Vector2) -> void:
	rotation = direction.angle()

func launch(direction: Vector2, force: float, facing_direction: bool = true) -> void:
	if facing_direction:
		face(direction)
	direction = direction.normalized()
	apply_central_impulse(direction * force)
