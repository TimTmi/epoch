class_name DamageContext


var combat: CombatSystem
var source: Character
var target: Character
var amount: float


func _init(combat: CombatSystem, source: Character, target: Character, amount: float) -> void:
	self.combat = combat
	self.source = source
	self.target = target
	self.amount = amount

func copy() -> DamageContext:
	return DamageContext.new(combat, source, target, amount)
