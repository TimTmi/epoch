class_name EffectSystem


#Dictionary[Character, Array[Effect]]
var effects_by_character: Dictionary[Character, Array]


func before_damage_dealt(context: DamageContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.source, []):
		effect.before_damage_dealt(context)

func before_damage_taken(context: DamageContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.target, []):
		effect.before_damage_taken(context)

func before_healing_given(context: HealingContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.source, []):
		effect.before_healing_given(context)

func before_healing_received(context: HealingContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.target, []):
		effect.before_healing_received(context)

func before_health_change(context: HealthChangeContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.character, []):
		effect.before_health_change(context)

func after_health_change(context: HealthChangeContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.character, []):
		effect.after_health_change(context)
	
func after_healing_received(context: HealingContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.target, []):
		effect.after_healing_received(context)

func after_healing_given(context: HealingContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.source, []):
		effect.after_healing_given(context)
	
func after_damage_taken(context: DamageContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.target, []):
		effect.after_damage_taken(context)
	
func after_damage_dealt(context: DamageContext) -> void:
	for effect: Effect in effects_by_character.get_or_add(context.source, []):
		effect.after_damage_dealt(context)
