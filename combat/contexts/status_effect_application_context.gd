class_name StatusEffectApplicationContext


var source: Character
var target: Character
var effect: StatusEffect


func _init(source: Character, target: Character, effect: StatusEffect) -> void:
	self.source = source
	self.target = target
	self.effect = effect
