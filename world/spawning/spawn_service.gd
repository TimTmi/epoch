class_name SpawnService


var _spawner: Spawner


signal character_spawned(character: Character)
signal projectile_spawned(projectile: Projectile)
signal hitbox_spawned(hitbox: Hitbox)
signal strand_spawned(strand: Strand)


func _init(_spawner: Spawner) -> void:
	self._spawner = _spawner

func spawn_character(config: CharacterConfig, team: StringName, position: Vector2 = Vector2.ZERO) -> Character:
	var character: Character = _spawner.spawn_character(config, team, position)
	if character == null:
		return null
	
	character_spawned.emit(character)
	return character

func spawn_projectile(scene: PackedScene, team: StringName, position: Vector2 = Vector2.ZERO) -> Projectile:
	var projectile: Projectile = _spawner.spawn_projectile(scene, team, position)
	if projectile == null:
		return null
	
	projectile_spawned.emit(projectile)
	return projectile

func spawn_hitbox(scene: PackedScene, team: StringName) -> Hitbox:
	var hitbox: Hitbox = _spawner.spawn_hitbox(scene, team)
	if hitbox == null:
		return null
	
	hitbox_spawned.emit(hitbox)
	return hitbox

func spawn_strand(config: StrandConfig) -> Strand:
	var strand: Strand = _spawner.spawn_strand(config)
	strand_spawned.emit(strand)
	return strand
