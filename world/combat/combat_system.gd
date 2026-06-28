class_name CombatSystem


var effect_system: EffectSystem = EffectSystem.new()


signal damage_dealt(context: DamageContext)
signal damage_taken(context: DamageContext)
signal healed(context: HealingContext)
signal health_changed(context: HealthChangeContext)


func deal_damage(source: Character, target: Character, amount: float) -> void:
	var damage_context: DamageContext = DamageContext.new(self, source, target, amount)
	
	effect_system.before_damage_dealt(damage_context)
	effect_system.before_damage_taken(damage_context)
	var new_target: Character = damage_context.target
	var health_change_context: HealthChangeContext = HealthChangeContext.new(self, new_target, new_target.health.current, new_target.health.current - damage_context.amount)
	effect_system.before_health_change(health_change_context)
	
	health_change_context.character.health.current = health_change_context.new_health
	
	effect_system.after_health_change(health_change_context)
	health_changed.emit(health_change_context)
	effect_system.after_damage_taken(damage_context)
	damage_taken.emit(damage_context)
	effect_system.after_damage_dealt(damage_context)
	damage_dealt.emit(damage_context)

func heal(context: HealingContext) -> void:
	context.target.receive_healing(context)
	healed.emit(context)

func apply_effect(source: Character, target: Character, effect: StatusEffect) -> void:
	target.status_effect_system.apply_effect(effect, source)

func add_effect(character: Character, effect: Effect) -> void:
	var effects: Array = effect_system.effects_by_character.get_or_add(character, [])
	effects.append(effect)

func remove_effect(character: Character, effect: Effect) -> void:
	var effects: Array = effect_system.effects_by_character.get(character)
	if effects:
		effects.erase(effect)
