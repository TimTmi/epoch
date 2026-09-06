class_name AbilityInstance


var ability: Ability
var cooldown_remaining: float = 0.0:
	set(value):
		cooldown_remaining = maxf(0.0, value)

var current_step: int = 0
var chain_timer: float = 0.0
var is_holding: bool = false
var hold_elapsed: float = 0.0
var pending_step: int = 0


signal started
signal ended


func _init(ability: Ability) -> void:
	self.ability = ability

func tick(delta: float) -> void:
	cooldown_remaining -= delta

	if is_holding:
		hold_elapsed += delta
	elif chain_timer > 0.0:
		chain_timer -= delta
		if chain_timer <= 0.0:
			current_step = 0

func press(context: AbilityContext) -> bool:
	if is_holding:
		return false

	var next_step: int = _next_step()

	if ability.step_trigger(next_step) == AbilityStep.Trigger.HOLD:
		if not can_activate(context):
			return false
		pending_step = next_step
		is_holding = true
		hold_elapsed = 0.0
		return true

	return _fire_step(context, next_step, 0.0)

func release(context: AbilityContext) -> bool:
	if not is_holding:
		return false

	var step: int = pending_step
	is_holding = false
	return _fire_step(context, step, hold_elapsed)

func can_activate(context: AbilityContext) -> bool:
	return cooldown_remaining <= 0.0 and ability.can_activate(context)

func _fire_step(context: AbilityContext, step: int, hold_duration: float) -> bool:
	if not can_activate(context):
		return false

	context.step = step
	context.hold_duration = hold_duration
	current_step = step
	chain_timer = ability.step_window
	_fire(context)
	return true

func _fire(context: AbilityContext) -> void:
	started.emit()
	cooldown_remaining = ability.cooldown
	await ability.activate(context)
	ended.emit()

func _next_step() -> int:
	var next_step: int = current_step + 1
	if next_step > ability.step_count():
		next_step = 1
	return next_step
