extends Controller


@export var direction: Vector2 = Vector2.RIGHT


func _computer_controller():
	character.move(direction)
	direction = direction.rotated(PI/90)
