class_name NodeBody extends StrandBody


var body: Node2D
var mass: float


func _init(_body: Node2D, _mass: float) -> void:
	body = _body
	mass = _mass

func get_position() -> Vector2:
	return body.position

func get_inverse_mass() -> float:
	return 1.0 / mass

func move(delta: Vector2) -> void:
	body.position += delta
