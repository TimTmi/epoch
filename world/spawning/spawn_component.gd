class_name SpawnComponent


var _spawn: SpawnService
var _character: Character
var _team: StringName
var _physics_profile: PhysicsProfile


func _init(spawn: SpawnService, character: Character) -> void:
	_spawn = spawn
	_character = character
	_team = character.team
	_physics_profile = character.physics_profile

func spawn_local_hitbox(scene: PackedScene) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitbox.setup_physics(_physics_profile)
	
	_character.add_child(hitbox)
	return hitbox

func spawn_global_hitbox(scene: PackedScene) -> Hitbox:
	var hitbox: Hitbox = _spawn.spawn_hitbox(scene, _team)
	if hitbox == null:
		return null
	
	hitbox.setup_physics(_physics_profile)
	
	return hitbox

func spawn_projectile(scene: PackedScene) -> Projectile:
	var projectile: Projectile = _spawn.spawn_projectile(scene, _team)
	if projectile == null:
		return null
	
	projectile.setup_physics(_physics_profile)
	
	return projectile

func spawn_vfx(scene: PackedScene) -> Node2D:
	var vfx = scene.instantiate()
	
	_character.add_child(vfx)
	return vfx
