class_name CombatSystem


#var rule_system: CombatRuleSystem = CombatRuleSystem.new()


var ruleset: Dictionary[StringName, CallableArray]


signal damage_dealt(context: DamageContext)
signal damage_taken(context: DamageContext)
signal healed(context: HealingContext)
signal health_changed(context: HealthChangeContext)


func deal_damage(source: Character, target: Character, amount: float) -> void:
	var damage_context: DamageContext = DamageContext.new(self, source, target, amount)
	
	_process_handlers(damage_context.source, RuleKey.Phase.BEFORE, RuleKey.Hook.DAMAGE_DEALT, damage_context)
	_process_handlers(damage_context.target, RuleKey.Phase.BEFORE, RuleKey.Hook.DAMAGE_TAKEN, damage_context)
	var new_target: Character = damage_context.target
	var health_change_context: HealthChangeContext = HealthChangeContext.new(self, new_target, new_target.health.current, new_target.health.current - damage_context.amount)
	_process_handlers(new_target, RuleKey.Phase.BEFORE, RuleKey.Hook.HEALTH_CHANGED, health_change_context)
	
	health_change_context.character.health.current = health_change_context.new_health
	
	_process_handlers(new_target, RuleKey.Phase.AFTER, RuleKey.Hook.HEALTH_CHANGED, health_change_context)
	health_changed.emit(health_change_context)
	_process_handlers(damage_context.target, RuleKey.Phase.AFTER, RuleKey.Hook.DAMAGE_TAKEN, damage_context)
	damage_taken.emit(damage_context)
	_process_handlers(damage_context.source, RuleKey.Phase.AFTER, RuleKey.Hook.DAMAGE_DEALT, damage_context)
	damage_dealt.emit(damage_context)

func heal(context: HealingContext) -> void:
	context.target.receive_healing(context)
	healed.emit(context)

func apply_effect(source: Character, target: Character, effect: StatusEffect) -> void:
	target.status_effect_system.apply_effect(effect, source)

func _get_handlers(key: RuleKey, auto_insert: bool = false) -> CallableArray:
	if ruleset.has(key.value):
		return ruleset.get(key.value)
	
	var empty_array: CallableArray = CallableArray.new()
	if auto_insert:
		ruleset.set(key.value, empty_array)
	return empty_array

func _process_handlers(character: Character, phase: RuleKey.Phase, hook: RuleKey.Hook, context: Variant) -> void:
	var key: RuleKey = RuleKey.new(character, phase, hook)
	var handlers: CallableArray = _get_handlers(key)
	handlers.call_all(context)

func add_rule(rule: CombatRule) -> void:
	var handlers: CallableArray = _get_handlers(rule.key, true)
	handlers.append(rule.handler)

func add_rules(rules: Array[CombatRule]) -> void:
	for rule: CombatRule in rules:
		add_rule(rule)

func remove_rule(rule: CombatRule) -> void:
	var handlers: CallableArray = _get_handlers(rule.key)
	handlers.erase(rule.handler)

func remove_rules(rules: Array[CombatRule]) -> void:
	for rule: CombatRule in rules:
		remove_rule(rule)
