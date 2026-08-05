class_name ZigZagFormation extends StrandFormation


@export var start: Vector2
@export var direction: Vector2
@export var length: float
@export var compressed_span: float
@export var fold_count: int


func _init(_start: Vector2 = Vector2.ZERO, _direction: Vector2 = Vector2.ZERO, _length: float = 0.0, _compressed_span: float = 0.0, _fold_count: int = 0) -> void:
	start = _start
	direction = _direction.normalized()
	length = _length
	compressed_span = _compressed_span
	fold_count = _fold_count

func get_length() -> float:
	return length

func sample(distance: float) -> Vector2:
	distance = clampf(distance, 0.0, length)
	
	var segment_count: int = fold_count * 2
	var segment_length: float = length / segment_count
	
	var segment: int = mini(int(distance / segment_length), segment_count - 1)
	var t: float = (distance - segment * segment_length) / segment_length
	
	var a: Vector2 = _vertex(segment)
	var b: Vector2 = _vertex(segment + 1)
	
	return a.lerp(b, t)

func _vertex(index: int) -> Vector2:
	if index == 0:
		return start
	
	if index == fold_count * 2:
		return start + direction * compressed_span
	
	var forward_step: float = compressed_span / (fold_count * 2)
	var segment_length: float = length / (fold_count * 2)
	
	var fold_width: float = sqrt(
		maxf(
			segment_length * segment_length - forward_step * forward_step,
			0.0
		)
	)
	
	var perpendicular: Vector2 = direction.orthogonal()
	
	var side: float = fold_width
	if index % 2 == 0:
		side = -side
	
	return start + direction * (index * forward_step) + perpendicular * side
