class_name PhysicsInteractionRule extends Resource


@export var source: PhysicsSublayer.Type
@export var target: PhysicsSublayer.Type

@export_flags("Same team layer", "Same team mask", "Other team layer", "Other team mask") var flags: int


func _init(source: PhysicsSublayer.Type, target: PhysicsSublayer.Type, flags: int) -> void:
	self.source = source
	self.target = target
	self.flags = flags
