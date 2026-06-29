class_name CombatSystem


var rule_system: CombatRuleSystem = CombatRuleSystem.new()


signal damage_dealt(context: DamageContext)
signal damage_taken(context: DamageContext)
signal healed(context: HealingContext)
signal health_changed(context: HealthChangeContext)


func deal_damage(source: Character, target: Character, amount: float) -> void:
	var damage_context: DamageContext = DamageContext.new(self, source, target, amount)
	
	rule_system.before_damage_dealt(damage_context)
	rule_system.before_damage_taken(damage_context)
	var new_target: Character = damage_context.target
	var health_change_context: HealthChangeContext = HealthChangeContext.new(self, new_target, new_target.health.current, new_target.health.current - damage_context.amount)
	rule_system.before_health_change(health_change_context)
	
	health_change_context.character.health.current = health_change_context.new_health
	
	rule_system.after_health_change(health_change_context)
	health_changed.emit(health_change_context)
	rule_system.after_damage_taken(damage_context)
	damage_taken.emit(damage_context)
	rule_system.after_damage_dealt(damage_context)
	damage_dealt.emit(damage_context)

func heal(context: HealingContext) -> void:
	context.target.receive_healing(context)
	healed.emit(context)

func apply_effect(source: Character, target: Character, effect: StatusEffect) -> void:
	target.status_effect_system.apply_effect(effect, source)

func add_rule(character: Character, rule: CombatRule) -> void:
	rule_system.add_rule(character, rule)

func remove_rule(character: Character, rule: CombatRule) -> void:
	rule_system.remove_rule(character, rule)
