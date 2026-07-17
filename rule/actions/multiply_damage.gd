class_name MultiplyDamageDealt extends RuleAction


var multiplier: float


func _init(multiplier: float) -> void:
	self.multiplier = multiplier

func execute(context: Variant) -> void:
	if context is DamageContext:
		context.amount *= multiplier
