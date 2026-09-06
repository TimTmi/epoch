class_name Stun extends StatusEffect


const PULSE_COLOR: Color = Color.YELLOW


func get_name() -> StringName:
	return "stun"

func apply(instance: StatusEffectInstance) -> void:
	instance.owner.input.lock()
	ModulationPulse.flash(instance.owner, PULSE_COLOR)

func remove(reason: StatusEffectRemovalReason.Type, instance: StatusEffectInstance) -> void:
	instance.owner.input.unlock()
