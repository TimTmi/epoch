class_name Hitbox extends Area2D


func setup_physics(physics_profile: PhysicsProfile) -> void:
	self.collision_layer = physics_profile.hitbox_layer
	self.collision_mask = physics_profile.hitbox_mask
