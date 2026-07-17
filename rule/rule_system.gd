class_name RuleSystem


class RuleInstanceArray:
	var array: Array[RuleInstance] = []
	
	
	func append(instance: RuleInstance) -> void:
		array.append(instance)

	func erase(instance: RuleInstance) -> void:
		array.erase(instance)
		
	func apply_all(trigger: Character, event_context: Variant) -> void:
		for instance: RuleInstance in array:
			instance.rule.apply(RuleContext.new(instance.owner, trigger, event_context))
	
	func _to_string() -> String:
		return str(array)


var rules: Dictionary[StringName, RuleInstanceArray]


func _get_rules(event: RuleEvent, auto_insert: bool = false) -> RuleInstanceArray:
	var key: StringName = event.key
	if rules.has(key):
		return rules.get(key)
	
	var empty_array: RuleInstanceArray = RuleInstanceArray.new()
	if auto_insert:
		rules.set(key, empty_array)
	return empty_array

func process(trigger: Character, script: GDScript, id: int, event_context: Variant, operation: Callable) -> void:
	_get_rules(RuleEvent.new(RuleEvent.Phase.BEFORE, script, id)).apply_all(trigger, event_context)
	operation.call(event_context)
	_get_rules(RuleEvent.new(RuleEvent.Phase.AFTER, script, id)).apply_all(trigger, event_context)

func add_rule(instance: RuleInstance) -> void:
	var rule: Rule = instance.rule
	var rules: RuleInstanceArray = _get_rules(rule.event, true)
	rules.append(instance)
	print(rules)

func add_rules(instances: Array[RuleInstance]) -> void:
	for instance: RuleInstance in instances:
		add_rule(instance)

func remove_rule(instance: RuleInstance) -> void:
	var rule: Rule = instance.rule
	var rules: RuleInstanceArray = _get_rules(rule.event)
	rules.erase(instance)

func remove_rules(instances: Array[RuleInstance]) -> void:
	for instance: RuleInstance in instances:
		remove_rule(instance)
