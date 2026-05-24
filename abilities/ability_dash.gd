extends Ability


@export var force: int = 600


func _use(input: Vector2) -> void:
	var direction = to_direction(input)
	user.push(direction * force)
	end()
