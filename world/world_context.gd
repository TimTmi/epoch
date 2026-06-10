class_name WorldContext


var world: World
var spawn: SpawnService


func _init(world: World, spawn_service: SpawnService) -> void:
	self.world = world
	spawn = spawn_service
