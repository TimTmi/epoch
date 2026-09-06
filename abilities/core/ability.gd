class_name Ability extends Resource


@export var icon: Texture = preload("uid://bo7j37st0tbcc")
@export var cooldown: float = 0.1
# Movement multiplier applied while a HOLD step is being held (1.0 = normal, 0.0 = immobile)
@export var hold_movement_multiplier: float = 1.0
@export var steps: Array[AbilityStep] = []
@export var step_window: float = 0.8


func can_activate(context: AbilityContext) -> bool:
	return true

func activate(context: AbilityContext) -> void:
	pass

# Called every physics frame while a HOLD step is being held, before activation.
func hold_tick(context: AbilityContext, hold_elapsed: float) -> void:
	pass

func step_count() -> int:
	return maxi(steps.size(), 1)

func step_trigger(step: int) -> AbilityStep.Trigger:
	if steps.is_empty():
		return AbilityStep.Trigger.CLICK
	return steps[step - 1].trigger

func step_cooldown(step: int) -> float:
	if steps.is_empty():
		return cooldown
	var step_cooldown: float = steps[step - 1].cooldown
	return cooldown if step_cooldown < 0.0 else step_cooldown

func step_advance_mode(step: int) -> AbilityStep.AdvanceMode:
	if steps.is_empty():
		return AbilityStep.AdvanceMode.DISCARD
	return steps[step - 1].advance_mode
