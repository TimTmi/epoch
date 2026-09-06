class_name Ability extends Resource


@export var icon: Texture = preload("uid://bo7j37st0tbcc")
@export var cooldown: float = 0.1
@export var steps: Array[AbilityStep] = []
@export var step_window: float = 0.8


func can_activate(context: AbilityContext) -> bool:
	return true

func activate(context: AbilityContext) -> void:
	pass

func step_count() -> int:
	return maxi(steps.size(), 1)

func step_trigger(step: int) -> AbilityStep.Trigger:
	if steps.is_empty():
		return AbilityStep.Trigger.CLICK
	return steps[step - 1].trigger
