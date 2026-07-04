class_name CombatRule


var key: RuleKey
var handler: Callable

func _init(key: RuleKey, handler: Callable) -> void:
	self.key = key
	self.handler = handler
