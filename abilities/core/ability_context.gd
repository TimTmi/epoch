class_name AbilityContext


var caster: AbilityCaster
var targeting: AbilityTargeting
var ability_system: AbilitySystem
var instance: AbilityInstance


func _init(intent: AbilityIntent, user: Character, ability_system: AbilitySystem, instance: AbilityInstance) -> void:
	self.ability_system = ability_system
	self.instance = instance
	self.caster = AbilityCaster.new(user)
	self.targeting = AbilityTargeting.new(intent, user.global_position)
