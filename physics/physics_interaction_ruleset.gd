class_name PhysicsInteractionRuleset extends Resource


enum InteractionFlag {
	NONE = 0,
	
	SAME_TEAM_LAYER = 1 << 0,
	SAME_TEAM_MASK = 1 << 1,
	OTHER_TEAM_LAYER = 1 << 2,
	OTHER_TEAM_MASK = 1 << 3,
	
	ALL = SAME_TEAM_LAYER | SAME_TEAM_MASK | OTHER_TEAM_LAYER | OTHER_TEAM_MASK
}


@export_flags("Same team layer", "Same team mask", "Other team layer", "Other team mask") var default_rule: int = InteractionFlag.ALL
@export var custom_rules: Array[PhysicsInteractionRule]


func get_flags(source: PhysicsSublayer.Type, target: PhysicsSublayer.Type) -> int:
	for rule: PhysicsInteractionRule in custom_rules:
		if rule.source == source and rule.target == target:
			return rule.flags
	
	return default_rule
