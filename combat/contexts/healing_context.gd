class_name HealingContext


var source: Character
var target: Character
var amount: float


func _init(source: Character, target: Character, amount: float) -> void:
	self.source = source
	self.target = target
	self.amount = amount

func copy() -> HealingContext:
	return HealingContext.new(source, target, amount)
