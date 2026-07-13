class_name RuleSystem


var before_rules: Dictionary[Callable, CallableArray]
var after_rules: Dictionary[Callable, CallableArray]


func _get_rules_by_phase(phase: Rule.Phase) -> Dictionary[Callable, CallableArray]:
	match phase:
		Rule.Phase.BEFORE:
			return before_rules
		Rule.Phase.AFTER:
			return after_rules
		_:
			push_error("invalid phase: %s" %phase)
			return {}

func _get_actions(phase: Rule.Phase, trigger: Callable, auto_insert: bool = false) -> CallableArray:
	var rules: Dictionary[Callable, CallableArray] = _get_rules_by_phase(phase)
	if rules.has(trigger):
		return rules.get(trigger)
	
	var empty_array: CallableArray = CallableArray.new()
	if auto_insert:
		rules.set(trigger, empty_array)
	return empty_array

func process_actions(phase: Rule.Phase, trigger: Callable, ...args) -> void:
	var actions: CallableArray = _get_actions(phase, trigger)
	actions.call_all.callv(args)

func add_rule(rule: Rule) -> void:
	var actions: CallableArray = _get_actions(rule.phase, rule.trigger, true)
	actions.append(rule.action)

func add_rules(rules: Array[Rule]) -> void:
	for rule: Rule in rules:
		add_rule(rule)

func remove_rule(rule: Rule) -> void:
	var actions: CallableArray = _get_actions(rule.phase, rule.trigger)
	actions.erase(rule.action)

func remove_rules(rules: Array[Rule]) -> void:
	for rule: Rule in rules:
		remove_rule(rule)
