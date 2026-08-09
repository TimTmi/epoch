class_name Projectile extends RigidBody2D


func setup_physics(physics_profile: PhysicsProfile) -> void:
	self.collision_layer = physics_profile.projectile_layer
	self.collision_mask = physics_profile.projectile_mask
