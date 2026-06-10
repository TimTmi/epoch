class_name Spawner extends Node


var world_context: WorldContext
var mask_resolver: PhysicsMaskResolver
var characters_container: Node2D
var projectiles_container: Node2D


func setup(world_context: WorldContext, mask_resolver: PhysicsMaskResolver, characters_container: Node2D, projectiles_container: Node2D):
	self.world_context = world_context
	self.mask_resolver = mask_resolver
	self.characters_container = characters_container
	self.projectiles_container = projectiles_container

func spawn_character(character: Character, team: StringName) -> void:
	character.setup(world_context, team, mask_resolver)
	characters_container.add_child(character)
