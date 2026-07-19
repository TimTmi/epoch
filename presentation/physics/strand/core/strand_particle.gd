class_name StrandParticle


var position: Vector2
var previous_position: Vector2
var acceleration: Vector2
var inverse_mass: float


func _init(_position: Vector2, _inverse_mass: float) -> void:
	position = _position
	previous_position = _position
	acceleration = Vector2.ZERO
	inverse_mass = _inverse_mass

func add_force(force: Vector2) -> void:
	acceleration += force * inverse_mass
