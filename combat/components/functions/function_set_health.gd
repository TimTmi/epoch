extends ComponentFunction


@export var health: Stat

var function: Callable = func(value: float, _character: Character):
	health.current = value
