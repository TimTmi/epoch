class_name RuleInstance


var owner: Character
var rule: Rule


func _init(owner: Character, rule: Rule) -> void:
	self.owner = owner
	self.rule = rule

func _to_string() -> String:
	return "{\n\towner: %s\n\trule: %s}" % [owner, rule]
