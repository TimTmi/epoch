class_name SpawnService


var world: World


func _init(world: World) -> void:
	self.world = world

func spawn_character(config: CharacterConfig, team: StringName) -> void:
	world.spawn_character(config, team)
