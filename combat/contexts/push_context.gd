class_name PushContext


var source: Character
var target: Character
var direction: Vector2
var force: float


func _init(source: Character, target: Character, direction: Vector2, force: float) -> void:
	self.source = source
	self.target = target
	self.direction = direction
	self.force = force
