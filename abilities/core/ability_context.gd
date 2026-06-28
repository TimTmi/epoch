class_name AbilityContext


var targeting: AbilityTargeting
var instance: AbilityInstance
var user: Character
var ability_system: AbilitySystem
var combat: CombatSystem


func _init(intent: AbilityIntent, user: Character, ability_system: AbilitySystem, instance: AbilityInstance, combat: CombatSystem) -> void:
	self.targeting = AbilityTargeting.new(intent, user.global_position)
	self.instance = instance
	self.user = user
	self.ability_system = ability_system
	self.combat = combat
