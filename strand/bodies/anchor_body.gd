class_name AnchorStrandBody extends StrandBody


var position: Vector2


func _init(_position: Vector2) -> void:
	position = _position

func get_position() -> Vector2:
	return position

func get_inverse_mass() -> float:
	return 0.0

func move(_delta: Vector2) -> void:
	pass
