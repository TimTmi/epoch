class_name StrandDistanceConstraint extends StrandConstraint


var a: StrandParticle
var b: StrandParticle
var rest_length: float


func _init(_a: StrandParticle, _b: StrandParticle, _rest_length: float) -> void:
	a = _a
	b = _b
	rest_length = _rest_length

func solve() -> void:
	var delta: Vector2 = b.position - a.position
	var distance: float = delta.length()
	if is_zero_approx(distance):
		return
	
	var total_inverse_mass: float = a.inverse_mass + b.inverse_mass
	if is_zero_approx(total_inverse_mass):
		return
	
	var error: float = distance - rest_length
	if is_zero_approx(error):
		return
	
	var correction: Vector2 = delta / distance * error
	var weight_a: float = a.inverse_mass / total_inverse_mass
	var weight_b: float = b.inverse_mass / total_inverse_mass
	
	a.position += correction * weight_a
	b.position -= correction * weight_b
