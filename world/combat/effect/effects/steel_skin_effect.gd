class_name SteelSkinEffect extends Effect


func before_damage_taken(context: DamageContext) -> void:
	context.amount = max(1, context.amount)
