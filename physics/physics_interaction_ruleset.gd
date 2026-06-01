class_name PhysicsInteractionRuleset extends Resource


@export_flags("Same team layer", "Same team mask", "Other team layer", "Other team mask") var default_rule: int = PhysicsInteractionFlag.Type.ALL
@export var custom_rules: Array[PhysicsInteractionRule]


func get_flags(source: PhysicsSublayer.Type, target: PhysicsSublayer.Type) -> int:
	for rule: PhysicsInteractionRule in custom_rules:
		if rule.source == source and rule.target == target:
			return rule.flags
	
	return default_rule
