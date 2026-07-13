class_name RuleKey


enum Phase { BEFORE, AFTER }


var value: StringName


func _init(event: Callable, phase: Phase) -> void:
	value = "%s:%s" %[event.get_method(), phase]
