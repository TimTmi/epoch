class_name Dash extends Ability


@export var force: int = 600


func activate(context: AbilityContext) -> void:
	var caster: AbilityCaster = context.caster
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return
	
	caster.impulse(direction * force)
