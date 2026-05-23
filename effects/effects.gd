extends Node
class_name Effects


var effects: Dictionary
enum StackType {STACK_ADD, STACK_REPLACE, STACK_IGNORE}


func has_effect(effect: Effect) -> bool:
	return effect.effect_name in effects

func add_effect(effect: Effect) -> void:
	effects[effect.effect_name].append(effect)
	add_child.call_deferred(effect)
	effect.tree_exiting.connect(_on_effect_ended.bind(effect))

func apply_effect(effect: Effect) -> void:
	var effect_name: String = effect.effect_name
	
	if !has_effect(effect):
		effects[effect_name] = []
	
	var effect_array: Array = effects[effect_name]
	var existing_effect: Effect
	
	if effect_array.is_empty():
		add_effect(effect)
		return
	
	match effect.stack_type:
		StackType.STACK_ADD:
			existing_effect = effect_array.front()
			existing_effect.start(existing_effect.time_left + effect.wait_time)
			effect.queue_free()
		
		StackType.STACK_REPLACE:
			existing_effect = effect_array.pop_back()
			existing_effect.queue_free()
			await existing_effect.tree_exited
			add_effect(effect)
			#print("effects: ", effects)
		
		StackType.STACK_IGNORE:
			add_effect(effect)

func _on_effect_ended(effect: Effect):
	effects[effect.effect_name].erase(effect)
