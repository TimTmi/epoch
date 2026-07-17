class_name Rule


enum Target {
	SELF = 1 << 0,
	ALLY = 1 << 1,
	ENEMY = 1 << 2,
	TEAM = SELF | ALLY,
	OTHERS = ALLY | ENEMY,
	ALL = SELF | ALLY | ENEMY
}


var event: RuleEvent
var target: int
var conditions: Array[RuleCondition]
var actions: Array[RuleAction]

func _init(source: Character, event: RuleEvent, target: int, conditions: Array[RuleCondition], actions: Array[RuleAction]) -> void:
	self.event = event
	self.target = target
	self.conditions = conditions
	self.actions = actions

func is_target(context: RuleContext) -> bool:
	if context.owner == context.trigger:
		return (target & Target.SELF) != 0

	if context.owner.is_same_team(context.trigger):
		return (target & Target.ALLY) != 0

	return (target & Target.ENEMY) != 0

func is_condition_met(context: Variant) -> bool:
	for condition: RuleCondition in conditions:
		if not condition.evaluate(context):
			return false
	
	return true

func matches(context: RuleContext) -> bool:
	return is_target(context) and is_condition_met(context.event_context)

func execute(context: Variant) -> void:
	for action: RuleAction in actions:
		action.execute(context)

func apply(context: RuleContext) -> void:
	if matches(context):
		execute(context.event_context)

func _to_string() -> String:
	return "{\n\tevent: %s\n\ttarget: %s\n\tconditions: %s\n\tactions: %s\n}" % [event, target, conditions, actions]
