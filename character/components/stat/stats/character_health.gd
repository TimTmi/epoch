class_name CharacterHealth extends CharacterStat


func set_current(value: float) -> void:
	value = clamp(value, 0, maximum)
	if value == current:
		return
	
	rules.process(
		character, CharacterStat, Event.CHANGED, StatChangeContext.new(character, current, value),
		func(context: StatChangeContext): super.set_current(context.new_stat)
	)

func lose(amount: float) -> void:
	rules.process(
		character, CharacterStat, Event.LOST, StatLossContext.new(character, amount),
		func(context: StatLossContext): super.lose(context.amount)
	)

func gain(amount: float) -> void:
	rules.process(
		character, CharacterHealth, Event.GAINED, StatGainContext.new(character, amount),
		func(context: StatGainContext): super.gain(context.amount)
	)
