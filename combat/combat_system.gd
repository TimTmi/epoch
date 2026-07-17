#class_name CombatSystem
#
#
##var rule_system: RuleSystem = RuleSystem.new()
#
#
#var ruleset: Dictionary[StringName, CallableArray]
#
#
#signal damage_dealt(context: DamageContext)
#signal damage_taken(context: DamageContext)
#signal healing_given(context: HealingContext)
#signal healing_received(context: HealingContext)
#signal health_changed(context: HealthChangeContext)
#signal dead(context: DeathContext)
#
#
#func kill(character: Character) -> void:
	#var context: DeathContext = DeathContext.new(character)
	#_process_handlers(context.character, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.DEATH, context)
	#_process_handlers(context.character, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.DEATH, context)
	#if context.dead:
		##do custom animation or shit
		#context.character.queue_free()
		#dead.emit(context)
#
#func set_health(character: Character, value: float) -> void:
	#var context: HealthChangeContext = HealthChangeContext.new(self, character, character.stats.health.current, value)
	#_process_handlers(context.character, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.HEALTH_CHANGED, context)
	#context.character.stats.health.current = context.new_health
	#_process_handlers(context.character, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.HEALTH_CHANGED, context)
	#health_changed.emit(context)
	#
	#if context.character.stats.health.current <= 0:
		#kill(context.character)
#
#func deal_damage(source: Character, target: Character, amount: float) -> void:
	#var context: DamageContext = DamageContext.new(self, source, target, amount)
	#
	#_process_handlers(context.source, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.DAMAGE_DEALT, context)
	#_process_handlers(context.target, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.DAMAGE_TAKEN, context)
	#
	#set_health(context.target, context.target.stats.health.current - context.amount)
	#
	#_process_handlers(context.target, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.DAMAGE_TAKEN, context)
	#damage_taken.emit(context)
	#_process_handlers(context.source, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.DAMAGE_DEALT, context)
	#damage_dealt.emit(context)
#
#func heal(source: Character, target: Character, amount: float) -> void:
	#var context: HealingContext = HealingContext.new(self, source, target, amount)
	#
	#_process_handlers(context.source, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.HEALING_GIVEN, context)
	#_process_handlers(context.target, InteractionRuleKey.Phase.BEFORE, InteractionRuleKey.Hook.HEALING_RECEIVED, context)
	#
	#set_health(context.target, context.target.health.current + context.amount)
	#
	#_process_handlers(context.target, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.HEALING_RECEIVED, context)
	#healing_received.emit(context)
	#_process_handlers(context.source, InteractionRuleKey.Phase.AFTER, InteractionRuleKey.Hook.HEALING_GIVEN, context)
	#healing_given.emit(context)
#
#func apply_status_effect(source: Character, target: Character, effect: StatusEffect) -> void:
	#target.status_effects.apply_status_effect(effect, source)
#
#func _get_handlers(key: InteractionRuleKey, auto_insert: bool = false) -> CallableArray:
	#if ruleset.has(key.value):
		#return ruleset.get(key.value)
	#
	#var empty_array: CallableArray = CallableArray.new()
	#if auto_insert:
		#ruleset.set(key.value, empty_array)
	#return empty_array
#
#func _process_handlers(character: Character, event: Callable, phase: RuleKey.Phase, participant: InteractionRuleKey.Participant, context: Variant) -> void:
	#var key: InteractionRuleKey = InteractionRuleKey.new(character, phase, hook)
	#var handlers: CallableArray = _get_handlers(key)
	#handlers.call_all(context)
#
#func add_rule(rule: Rule) -> void:
	#var handlers: CallableArray = _get_handlers(rule.key, true)
	#handlers.append(rule.handler)
#
#func add_rules(rules: Array[Rule]) -> void:
	#for rule: Rule in rules:
		#add_rule(rule)
#
#func remove_rule(rule: Rule) -> void:
	#var handlers: CallableArray = _get_handlers(rule.key)
	#handlers.erase(rule.handler)
#
#func remove_rules(rules: Array[Rule]) -> void:
	#for rule: Rule in rules:
		#remove_rule(rule)
