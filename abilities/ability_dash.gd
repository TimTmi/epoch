class_name Dash extends Ability


@export var force: int = 600


func activate(context: AbilityContext) -> void:
	var direction: Vector2 = context.get_target_direction()
	if direction == Vector2.INF:
		return
	
	context.user.push(direction * force)
