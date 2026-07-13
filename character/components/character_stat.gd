class_name CharacterStat


var character: Character

var minimum: float
var maximum: float
var current: float

var rule_system: RuleSystem


signal changed(context: StatChangeContext)
signal lost(context: StatLossContext)
signal gained(context: StatGainContext)


func _init(character: Character, config: StatConfig) -> void:
	self.character = character
	self.minimum = config.minimum
	self.maximum = config.maximum
	self.current = config.current
	rule_system = RuleSystem.new()

func set_current(value: float) -> void:
	var context: StatChangeContext = StatChangeContext.new(character, current, value)
	value = clamp(context.new_stat, 0, maximum)
	if value == current:
		return
	
	current = value
	changed.emit(context)

func lose(amount: float) -> void:
	var context: StatLossContext = StatLossContext.new(character, amount)
	rule_system.process_actions(Rule.Phase.BEFORE, lose, context)
	set_current(current - amount)
	rule_system.process_actions(Rule.Phase.AFTER, lose, context)
	lost.emit(context)

func gain(amount: float) -> void:
	var context: StatGainContext = StatGainContext.new(character, amount)
	rule_system.process_actions(Rule.Phase.BEFORE, gain, context)
	set_current(current + amount)
	rule_system.process_actions(Rule.Phase.AFTER, gain, context)
	gained.emit(context)
