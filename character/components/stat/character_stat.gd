class_name CharacterStat


var character: Character

var minimum: float
var maximum: float
var current: float

var rules: RuleSystem


enum Event {
	CHANGED,
	LOST,
	GAINED
}

signal changed(context: StatChangeContext)
signal lost(context: StatLossContext)
signal gained(context: StatGainContext)


func _init(character: Character, config: StatConfig) -> void:
	self.character = character
	self.minimum = config.minimum
	self.maximum = config.maximum
	self.current = config.current
	rules = RuleSystem.new()

func set_current(value: float) -> void:
	value = clamp(value, 0, maximum)
	if value == current:
		return
	
	rules.process(
		character, CharacterStat, Event.CHANGED, StatChangeContext.new(character, current, value),
		func(context: StatChangeContext):
			current = context.new_stat
			changed.emit(context)
	)

func lose(amount: float) -> void:
	rules.process(
		character, CharacterStat, Event.LOST, StatLossContext.new(character, amount),
		func(context: StatLossContext):
			set_current(current - amount)
			lost.emit(context)
	)

func gain(amount: float) -> void:
	rules.process(
		character, CharacterStat, Event.GAINED, StatGainContext.new(character, amount),
		func(context: StatGainContext):
			set_current(current + amount)
			gained.emit(context)
	)
