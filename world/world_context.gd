class_name WorldContext


var world: World
var spawn: SpawnService
var combat: CombatSystem


func _init(world: World, spawn_service: SpawnService, combat_system: CombatSystem) -> void:
	self.world = world
	spawn = spawn_service
	combat = combat_system
