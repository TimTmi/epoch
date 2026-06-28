class_name AbilitySystem


enum CommandSlot { PRIMARY, SECONDARY, UTILITY, SPECIAL, ULTIMATE, EXTRA_1, EXTRA_2, EXTRA_3 }

var slot_ability_instances: Dictionary[CommandSlot, AbilityInstance] = {}
var passive_ability_instances: Array[AbilityInstance] = []


func setup_abilities(slot_abilities: Dictionary[CommandSlot, Ability], passive_abilities: Array[Ability]) -> void:
	for slot: CommandSlot in slot_abilities:
		slot_ability_instances[slot] = AbilityInstance.new(slot_abilities.get(slot))
	
	for ability: Ability in passive_abilities:
		passive_ability_instances.append(AbilityInstance.new(ability))

func tick(delta: float) -> void:
	for instance: AbilityInstance in slot_ability_instances.values():
		instance.tick(delta)
	
	for instance: AbilityInstance in passive_ability_instances:
		instance.tick(delta)

func try_activate_ability_instance(instance: AbilityInstance, intent: AbilityIntent, user: Character, combat: CombatSystem) -> bool:
	var context: AbilityContext = AbilityContext.new(intent, user, self, instance, combat)
	
	if instance.can_activate(context):
		instance.activate(context)
		return true
	
	return false

func try_activate_slot(slot: CommandSlot, intent: AbilityIntent, user: Character, combat: CombatSystem) -> bool:
	var instance: AbilityInstance = slot_ability_instances.get(slot)
	if instance == null:
		return false
	
	return try_activate_ability_instance(instance, intent, user, combat)
