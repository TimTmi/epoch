class_name Rule


enum Phase { BEFORE, AFTER }


var phase: Phase
var trigger: Callable
var action: Callable

func _init(phase: Phase, trigger: Callable, action: Callable) -> void:
	self.phase = phase
	self.trigger = trigger
	self.action = action
