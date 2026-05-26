class_name AbilityInstance


var ability: Ability
var cooldown_remaining: float = 0.0:
	set(value):
		cooldown_remaining = maxf(0.0, value)


signal started
signal ended


func _init(ability: Ability) -> void:
	self.ability = ability

func tick(delta: float) -> void:
	cooldown_remaining -= delta

func can_activate(context: AbilityContext) -> bool:
	return cooldown_remaining <= 0.0 and ability.can_activate(context)

func activate(context: AbilityContext) -> void:
	started.emit()
	cooldown_remaining = ability.cooldown
	await ability.activate(context)
	ended.emit()
