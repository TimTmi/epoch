class_name RuleEvent


enum Phase { BEFORE, AFTER }


var phase: Phase
var owner: GDScript
var id: int

var key: StringName


func _init(phase: Phase, owner: GDScript, id: int) -> void:
	self.phase = phase
	self.owner = owner
	self.id = id
	self.key = _build_key()

func _build_key() -> StringName:
	return "%s.%s.%s" % [phase, owner, id]
