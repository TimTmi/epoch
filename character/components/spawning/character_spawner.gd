class_name CharacterSpawner


var character: Character
var world_context: WorldContext


func _init(character: Character, world_context: WorldContext) -> void:
	self.character = character
	self.world_context = world_context

func spawn_local_hitbox(scene: PackedScene) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitbox.setup_physics(character.physics_profile)
	
	character.add_child(hitbox)
	return hitbox

func spawn_global_hitbox(scene: PackedScene) -> Hitbox:
	return world_context.spawn.spawn_hitbox(scene, character.team)

func spawn_projectile(scene: PackedScene) -> Projectile:
	var projectile: Projectile = scene.instantiate()
	if projectile == null:
		return null
	
	#TODO: physics setup
	
	character.add_child(projectile)
	return projectile

func spawn_vfx(scene: PackedScene) -> Node2D:
	var vfx = scene.instantiate()
	
	character.add_child(vfx)
	return vfx
