class_name WorldServices


var world: World
var spawn: SpawnService
var combat_events: CombatEvents


func _init(world: World, spawn_service: SpawnService, combat_events: CombatEvents) -> void:
	self.world = world
	self.spawn = spawn_service
	self.combat_events = combat_events
