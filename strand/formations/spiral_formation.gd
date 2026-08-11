class_name SpiralFormation extends StrandFormation

@export var center: Vector2
@export var start_radius: float = 0.0
@export var end_radius: float = 100.0
@export var turns: float = 3.0
@export var start_angle: float = 0.0
@export var clockwise: bool = false
@export var resolution: int = 48

var _thetas: PackedFloat32Array
var _cum_lengths: PackedFloat32Array
var _total_length: float = 0.0

func _init(
	_center: Vector2 = Vector2.ZERO,
	_start_radius: float = 0.0,
	_end_radius: float = 100.0,
	_turns: float = 3.0,
	_start_angle: float = 0.0,
	_clockwise: bool = false,
	_resolution: int = 48
) -> void:
	center = _center
	start_radius = _start_radius
	end_radius = _end_radius
	turns = _turns
	start_angle = _start_angle
	clockwise = _clockwise
	resolution = _resolution
	
	_build_lookup()

func _radius_at_theta(theta: float, total_angle: float) -> float:
	if total_angle == 0.0:
		return start_radius
	return lerpf(start_radius, end_radius, theta / total_angle)

func _point_at_theta(theta: float, total_angle: float) -> Vector2:
	var signed_theta: float = -theta if clockwise else theta
	var angle: float = start_angle + signed_theta
	var r: float = _radius_at_theta(theta, total_angle)
	return center + Vector2(cos(angle), sin(angle)) * r

func _build_lookup() -> void:
	var total_angle: float = turns * TAU
	var steps: int = max(int(resolution * turns), 8)
	_thetas.resize(steps + 1)
	_cum_lengths.resize(steps + 1)

	var prev_point: Vector2 = _point_at_theta(0.0, total_angle)
	_thetas[0] = 0.0
	_cum_lengths[0] = 0.0
	var cumulative: float = 0.0

	for i in range(1, steps + 1):
		var theta: float = total_angle * float(i) / float(steps)
		var point: Vector2 = _point_at_theta(theta, total_angle)
		cumulative += prev_point.distance_to(point)
		_thetas[i] = theta
		_cum_lengths[i] = cumulative
		prev_point = point

	_total_length = cumulative

func get_length() -> float:
	return _total_length

func sample(distance: float) -> Vector2:
	distance = clampf(distance, 0.0, _total_length)
	var total_angle: float = turns * TAU

	var idx: int = _cum_lengths.bsearch(distance)
	if idx <= 0:
		return _point_at_theta(_thetas[0], total_angle)
	if idx >= _cum_lengths.size():
		return _point_at_theta(_thetas[_thetas.size() - 1], total_angle)

	var d0: float = _cum_lengths[idx - 1]
	var d1: float = _cum_lengths[idx]
	var t: float = 0.0 if d1 == d0 else (distance - d0) / (d1 - d0)
	var theta: float = lerpf(_thetas[idx - 1], _thetas[idx], t)
	return _point_at_theta(theta, total_angle)

func get_key_distances() -> PackedFloat32Array:
	return _cum_lengths
