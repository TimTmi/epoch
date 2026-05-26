class_name Ability extends Resource


@export var icon: Texture = preload("uid://bo7j37st0tbcc")
@export var cooldown: float = 0.1


func can_activate(context: AbilityContext) -> bool:
	return true

func activate(context: AbilityContext) -> void:
	pass
