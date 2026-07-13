class_name DamageContext


var source: Character
var target: Character
var amount: float


func _init(source: Character, target: Character, amount: float) -> void:
	self.source = source
	self.target = target
	self.amount = amount

func copy() -> DamageContext:
	return DamageContext.new(source, target, amount)
