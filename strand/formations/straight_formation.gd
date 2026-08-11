class_name StraightFormation extends StrandFormation


@export var start: Vector2
@export var direction: Vector2
@export var length: float


func _init(_start: Vector2 = Vector2.ZERO, _direction: Vector2 = Vector2.ZERO, _length: float = 0.0) -> void:
	start = _start
	direction = _direction.normalized()
	length = _length

func get_length() -> float:
	return length

func sample(distance: float) -> Vector2:
	return start + direction * clampf(distance, 0.0, length)
