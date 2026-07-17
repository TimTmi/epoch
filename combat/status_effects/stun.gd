class_name Stun extends StatusEffect


func get_name() -> StringName:
	return "stun"

func apply(instance: StatusEffectInstance) -> void:
	instance.owner.input.lock()

func remove(reason: StatusEffectRemovalReason.Type, instance: StatusEffectInstance) -> void:
	instance.owner.input.unlock()
