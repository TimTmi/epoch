class_name AbilityInstance


var ability: Ability
var cooldown_remaining: float = 0.0:
	set(value):
		cooldown_remaining = maxf(0.0, value)
var cooldown_total: float = 0.0

var current_step: int = 0
var chain_timer: float = 0.0
var is_holding: bool = false
var hold_elapsed: float = 0.0
var pending_step: int = 0
var _last_context: AbilityContext = null
var _hold_context: AbilityContext = null
var _deferred_advance: bool = false


signal started
signal ended


func _init(ability: Ability) -> void:
	# Own a copy of the config's shared ability resource: stateful abilities
	# (charging bolts, spawned walls, flames) keep per-user state on the
	# resource, which must not leak between characters sharing one config.
	self.ability = ability.duplicate(false) as Ability

func tick(delta: float) -> void:
	cooldown_remaining -= delta

	if is_holding:
		hold_elapsed += delta
		ability.hold_tick(_hold_context, hold_elapsed)
	elif _is_awaiting_step():
		pass
	elif chain_timer > 0.0:
		chain_timer -= delta
		if chain_timer <= 0.0:
			current_step = 0

	_fire_deferred_advance()

func press(context: AbilityContext) -> bool:
	if is_holding:
		return false

	var next_step: int = _next_step()
	var trigger: AbilityStep.Trigger = ability.step_trigger(next_step)

	if trigger == AbilityStep.Trigger.WAIT:
		return false

	if trigger == AbilityStep.Trigger.HOLD:
		if not can_activate(context):
			return false
		pending_step = next_step
		_hold_context = context
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

func reset_chain() -> void:
	current_step = 0
	chain_timer = 0.0
	is_holding = false
	hold_elapsed = 0.0
	pending_step = 0
	_deferred_advance = false

func advance() -> bool:
	if is_holding or _last_context == null:
		return false
	if can_activate(_last_context):
		_commit_step(_last_context, _next_step(), 0.0)
		return true
	if ability.step_advance_mode(_next_step()) == AbilityStep.AdvanceMode.DEFER:
		_deferred_advance = true
		return true
	return false

func can_activate(context: AbilityContext) -> bool:
	return cooldown_remaining <= 0.0 and ability.can_activate(context)

func _fire_step(context: AbilityContext, step: int, hold_duration: float) -> bool:
	if not can_activate(context):
		return false

	_commit_step(context, step, hold_duration)
	return true

func _commit_step(context: AbilityContext, step: int, hold_duration: float) -> void:
	context.step = step
	context.hold_duration = hold_duration
	_last_context = context
	current_step = step
	chain_timer = ability.step_window
	cooldown_total = ability.step_cooldown(step)
	cooldown_remaining = cooldown_total
	_deferred_advance = false
	_fire(context)

func _fire_deferred_advance() -> void:
	if not _deferred_advance:
		return
	if cooldown_remaining > 0.0 or is_holding:
		return
	_deferred_advance = false
	_commit_step(_last_context, _next_step(), 0.0)

func _fire(context: AbilityContext) -> void:
	started.emit()
	await ability.activate(context)
	ended.emit()

func _next_step() -> int:
	var next_step: int = current_step + 1
	if next_step > ability.step_count():
		next_step = 1
	return next_step

func _is_awaiting_step() -> bool:
	return current_step > 0 and ability.step_trigger(_next_step()) == AbilityStep.Trigger.WAIT
