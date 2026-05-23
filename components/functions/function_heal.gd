extends ComponentFunction


var function: Callable = func(amount: float, _healer: Character, target: Character):
	#set_health.function.call(health.current + amount)
	target.set_health(target.health.current + amount)
	healed.emit(amount)


signal healed(amount: float)
