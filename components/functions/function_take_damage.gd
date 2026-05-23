extends ComponentFunction


var multiplier: float = 1
var flat_modifier: float = 0


var function: Callable = func(amount: float, attacker: Character, target: Character):
	amount = amount * multiplier + flat_modifier
	amount = handle(amount)
	target.set_health(target.health.current - amount)
	damage_taken.emit(amount, attacker)


signal damage_taken(amount: float, from: Character)
