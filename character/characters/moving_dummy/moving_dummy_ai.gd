class_name MovingDummyAI extends AIInput


var angle: float = 0
var rad_per_tick: float = PI * 0.02


func tick(_delta: float) -> void:
	character.move(Vector2.RIGHT.rotated(angle))
	angle += rad_per_tick
