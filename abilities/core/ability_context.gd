class_name AbilityContext


var targeting: AbilityTargeting
var instance: AbilityInstance
var user: Character
var abilities: AbilitySystem
var combat_events: CombatEvents


func _init(intent: AbilityIntent, user: Character, abilities: AbilitySystem, instance: AbilityInstance, combat_events: CombatEvents) -> void:
	self.targeting = AbilityTargeting.new(intent, user.global_position)
	self.instance = instance
	self.user = user
	self.abilities = abilities
	self.combat_events = combat_events
