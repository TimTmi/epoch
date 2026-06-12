class_name SpawnService


var spawner: Spawner


signal character_spawned(character: Character)
signal projectile_spawned(projectile: Projectile)
signal hitbox_spawned(hitbox: Hitbox)


func _init(spawner: Spawner) -> void:
	self.spawner = spawner

func spawn_character(config: CharacterConfig, team: StringName) -> Character:
	return spawner.spawn_character(config, team)

func spawn_projectile(scene: PackedScene, team: StringName) -> Projectile:
	return spawner.spawn_projectile(scene, team)

func spawn_hitbox(scene: PackedScene, team: StringName) -> Hitbox:
	return 
