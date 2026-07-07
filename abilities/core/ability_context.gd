class_name AbilityContext


var targeting: AbilityTargeting
var instance: AbilityInstance
var user: Character
var abilities: AbilitySystem
var combat: CombatSystem


func _init(intent: AbilityIntent, user: Character, abilities: AbilitySystem, instance: AbilityInstance, combat: CombatSystem) -> void:
	self.targeting = AbilityTargeting.new(intent, user.global_position)
	self.instance = instance
	self.user = user
	self.abilities = abilities
	self.combat = combat
