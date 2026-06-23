extends ComponentFunction


var multiplier: float = 1
var flat_modifier: float = 0


var function: Callable = func(amount: float, attacker: Character, target: Character, world_context: WorldContext):
	amount = amount * multiplier + flat_modifier
	amount = handle(amount)
	world_context.combat.deal_damage(amount, attacker, target)
	damage_dealt.emit(amount, target)


signal damage_dealt(amount: float, to: Character)
