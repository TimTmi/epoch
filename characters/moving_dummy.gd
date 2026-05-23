extends Character


@export var direction: Vector2 = Vector2.RIGHT


func _on_collision(body):
	direction = body.position - position
