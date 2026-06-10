class_name SpawnService


var spawner: Spawner


func _init(spawner: Spawner) -> void:
	self.spawner = spawner

func spawn_character(character: Character, team: StringName) -> void:
	spawner.spawn_character(character, team)
