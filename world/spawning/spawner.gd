class_name Spawner extends Node


var world_services: WorldServices
var mask_resolver: PhysicsMaskResolver
var characters_container: Node2D
var projectiles_container: Node2D
var hitboxes_container: Node2D
var strands_container: Node2D
var obstacles_container: Node2D


func setup(world_services: WorldServices, mask_resolver: PhysicsMaskResolver) -> void:
	self.world_services = world_services
	self.mask_resolver = mask_resolver
	var world: World = world_services.world
	characters_container = world.characters_container
	projectiles_container = world.projectiles_container
	hitboxes_container = world.hitboxes_container
	strands_container = world.strands_container
	obstacles_container = world.obstacles_container

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
	projectile.setup_physics(mask_resolver.get_profile(team))
	projectiles_container.add_child(projectile)
	
	return projectile

func spawn_strand(config: StrandConfig) -> Strand:
	var strand: Strand = Strand.new(config)
	strands_container.add_child(strand)
	return strand

func spawn_obstacle(scene: PackedScene, position: Vector2 = Vector2.ZERO, rotation: float = 0.0) -> Wall:
	var wall: Wall = scene.instantiate()
	if wall == null:
		return null

	wall.position = position
	wall.rotation = rotation
	wall.collision_layer = mask_resolver.get_layer(&"environment", PhysicsSublayer.Type.WALL)
	obstacles_container.add_child(wall)

	return wall

func spawn_hitbox(scene: PackedScene, team: StringName) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitbox.setup_physics(mask_resolver.get_profile(team))
	hitboxes_container.add_child(hitbox)

	return hitbox
