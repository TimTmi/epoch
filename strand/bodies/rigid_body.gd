class_name RigidStrandBody extends StrandBody


var body: RigidBody2D


func _init(_body: RigidBody2D) -> void:
	body = _body

func get_position() -> Vector2:
	return body.position

func get_inverse_mass() -> float:
	return 1.0 / body.mass

func move(delta: Vector2) -> void:
	body.position += delta
