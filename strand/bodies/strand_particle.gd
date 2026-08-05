class_name StrandParticle extends StrandBody


var position: Vector2
var previous_position: Vector2
var acceleration: Vector2
var mass: float:
	set(value):
		if value <= 0:
			push_error("particle mass must be larger than 0")
			return
		
		mass = value


func _init(_position: Vector2, _mass: float) -> void:
	position = _position
	previous_position = _position
	acceleration = Vector2.ZERO
	mass = _mass

func get_position() -> Vector2:
	return position

func get_inverse_mass() -> float:
	return 1.0 / mass

func move(delta: Vector2) -> void:
	position += delta

func add_force(force: Vector2) -> void:
	acceleration += force * get_inverse_mass()
