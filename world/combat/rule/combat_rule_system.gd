class_name CombatRuleSystem


#Dictionary[Character, Array[CombatRule]]
var rules_by_character: Dictionary[Character, Array]


func add_rule(character: Character, rule: CombatRule) -> void:
	var rules: Array = rules_by_character.get_or_add(character, [])
	rules.append(rule)

func remove_rule(character: Character, rule: CombatRule) -> void:
	var rules: Array = rules_by_character.get(character)
	if rules:
		rules.erase(rule)

func before_damage_dealt(context: DamageContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.source, []):
		rule.before_damage_dealt(context)

func before_damage_taken(context: DamageContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.target, []):
		rule.before_damage_taken(context)

func before_healing_given(context: HealingContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.source, []):
		rule.before_healing_given(context)

func before_healing_received(context: HealingContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.target, []):
		rule.before_healing_received(context)

func before_health_change(context: HealthChangeContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.character, []):
		rule.before_health_change(context)

func after_health_change(context: HealthChangeContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.character, []):
		rule.after_health_change(context)
	
func after_healing_received(context: HealingContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.target, []):
		rule.after_healing_received(context)

func after_healing_given(context: HealingContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.source, []):
		rule.after_healing_given(context)
	
func after_damage_taken(context: DamageContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.target, []):
		rule.after_damage_taken(context)
	
func after_damage_dealt(context: DamageContext) -> void:
	for rule: CombatRule in rules_by_character.get_or_add(context.source, []):
		rule.after_damage_dealt(context)
