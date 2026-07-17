class_name RuleContext


var owner: Character
var trigger: Character
var event_context: Variant


func _init(owner: Character, trigger: Character, event_context: Variant) -> void:
	self.owner = owner
	self.trigger = trigger
	self.event_context = event_context
