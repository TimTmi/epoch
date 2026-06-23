class_name StatusEffect


enum StackBehavior {
	ADD,
	REPLACE,
	IGNORE
}


var duration: float


func _init(duration: float) -> void:
	self.duration = duration

func get_name() -> StringName:
	return "status effect"

func get_default_stack_behavior() -> StackBehavior:
	return StackBehavior.ADD

func apply(instance: StatusEffectInstance) -> void:
	pass

func tick(delta: float, instance: StatusEffectInstance) -> void:
	pass

func remove(reason: StatusEffectRemovalReason.Type, instance: StatusEffectInstance) -> void:
	pass
