class_name AbilityContext


var targeting: AbilityTargeting
var instance: AbilityInstance
var user: Character
var abilities: AbilitySystem
var world_services: WorldServices


func _init(_intent: AbilityIntent, _user: Character, _abilities: AbilitySystem, _instance: AbilityInstance, _world_services: WorldServices) -> void:
	targeting = AbilityTargeting.new(_intent, _user.global_position)
	instance = _instance
	user = _user
	abilities = _abilities
	world_services = _world_services
