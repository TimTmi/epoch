class_name Spawner extends Node


var world_context: WorldContext
var mask_resolver: PhysicsMaskResolver
var characters_container: Node2D
var projectiles_container: Node2D
var hitboxes_container: Node2D


func setup(world_context: WorldContext, mask_resolver: PhysicsMaskResolver, characters_container: Node2D, projectiles_container: Node2D, hitboxes_container: Node2D):
	self.world_context = world_context
	self.mask_resolver = mask_resolver
	self.characters_container = characters_container
	self.projectiles_container = projectiles_container
	self.hitboxes_container = hitboxes_container

func spawn_character(config: CharacterConfig, team: StringName) -> Character:
	var character: Character = config.scene.instantiate()
	characters_container.add_child(character)
	character.apply_config(config)
	character.initialize(world_context, config, team, mask_resolver)
	return character

func spawn_projectile(scene: PackedScene, team: StringName) -> Projectile:
	var projectile: Projectile = scene.instantiate()
	if projectile == null:
		return null
	
	projectiles_container.add_child(projectile)
	
	return projectile

func spawn_hitbox(scene: PackedScene, team: StringName) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitboxes_container.add_child(hitbox)
	
	return hitbox
