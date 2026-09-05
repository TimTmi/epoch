class_name StrandDistanceConstraint extends StrandConstraint


var a: StrandBody
var b: StrandBody
var distance: float
var stiffness: float


func _init(_a: StrandBody, _b: StrandBody, _distance: float, _stiffness: float = 1.0) -> void:
	a = _a
	b = _b
	distance = _distance
	stiffness = _stiffness

func solve() -> void:
	var delta: Vector2 = b.get_position() - a.get_position()
	var current_distance: float = delta.length()
	if is_zero_approx(current_distance):
		return
	
	var total_inverse_mass: float = a.get_inverse_mass() + b.get_inverse_mass()
	if is_zero_approx(total_inverse_mass):
		return
	
	var error: float = current_distance - distance
	if is_zero_approx(error):
		return
	
	var correction: Vector2 = delta / current_distance * error * stiffness
	var weight_a: float = a.get_inverse_mass() / total_inverse_mass
	var weight_b: float = b.get_inverse_mass() / total_inverse_mass
	
	a.move(correction * weight_a)
	b.move(-correction * weight_b)
