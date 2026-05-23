extends ComponentFunction


var multiplier: float = 1
var flat_modifier: float = 0


var function: Callable = func(amount: float, attacker: Character, target: Character):
	amount = amount * multiplier + flat_modifier
	amount = handle(amount)
	target.take_damage(amount, attacker)
	damage_dealt.emit(amount, target)


signal damage_dealt(amount: float, to: Character)
