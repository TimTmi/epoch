class_name StatusEffectSystem


var character: Character
# Dictionary[StringName, Array[StatusEffectInstance]]
var status_effects: Dictionary[StringName, Array]


func _init(character: Character) -> void:
	self.character = character

func has_status_effect(effect_name: StringName) -> bool:
	return effect_name in status_effects

func apply_status_effect(context: StatusEffectApplicationContext) -> void:
	var source: Character = context.source
	var effect: StatusEffect = context.effect
	var effect_array: Array = status_effects.get_or_add(effect.get_name(), [])
	
	if effect_array.is_empty():
		_add_status_effect(effect, source, effect_array)
		return
	
	var existing_effect: StatusEffectInstance
	
	match effect.get_default_stack_behavior():
		StatusEffect.StackBehavior.ADD:
			existing_effect = effect_array.front()
			existing_effect.duration_remaining += effect.duration
		
		StatusEffect.StackBehavior.REPLACE:
			existing_effect = effect_array.pop_back()
			existing_effect.remove(StatusEffectRemovalReason.Type.REPLACED)
			_add_status_effect(effect, source, effect_array)
		
		StatusEffect.StackBehavior.IGNORE:
			_add_status_effect(effect, source, effect_array)

func _add_status_effect(effect: StatusEffect, source: Character, effect_array: Array) -> void:
	var instance: StatusEffectInstance = StatusEffectInstance.new(effect, source, character)
	effect_array.append(instance)
	instance.removed.connect(func(reason: StatusEffectRemovalReason.Type): effect_array.erase(instance))
	instance.apply()

func tick(delta: float) -> void:
	for effect_array: Array in status_effects.values():
		for effect: StatusEffectInstance in effect_array:
			effect.tick(delta)
