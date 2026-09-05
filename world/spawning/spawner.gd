class_name Spawner extends Node


var world_services: WorldServices
var mask_resolver: PhysicsMaskResolver
var characters_container: Node2D
var projectiles_container: Node2D
var hitboxes_container: Node2D
var strands_container: Node2D


func setup(world_services: WorldServices, mask_resolver: PhysicsMaskResolver, characters_container: Node2D, projectiles_container: Node2D, hitboxes_container: Node2D, strands_container: Node2D):
	self.world_services = world_services
	self.mask_resolver = mask_resolver
	self.characters_container = characters_container
	self.projectiles_container = projectiles_container
	self.hitboxes_container = hitboxes_container
	self.strands_container = strands_container

func spawn_character(config: CharacterConfig, team: StringName, position: Vector2 = Vector2.ZERO) -> Character:
	var character: Character = config.scene.instantiate()
	if character == null:
		return null
	character.position = position
	characters_container.add_child(character)
	character.initialize(world_services, config, team, mask_resolver.get_profile(team))
	return character

func spawn_projectile(scene: PackedScene, team: StringName, position: Vector2 = Vector2.ZERO) -> Projectile:
	var projectile: Projectile = scene.instantiate()
	if projectile == null:
		return null
	
	projectile.position = position
	projectiles_container.add_child(projectile)
	
	return projectile

func spawn_strand(strand: Strand) -> Strand:
	strands_container.add_child(strand)
	return strand

func spawn_hitbox(scene: PackedScene, team: StringName) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitboxes_container.add_child(hitbox)
	
	return hitbox
