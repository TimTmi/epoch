class_name CombatSystem


signal damage_dealt(amount: float, source: Character, target: Character)
signal damage_taken(amount: float, target: Character, source: Character)
signal healed(amount: float, target: Character, source: Character)


func deal_damage(amount: float, source: Character, target: Character) -> void:
	target.take_damage(amount, source)
	damage_dealt.emit(amount, source, target)
	damage_taken.emit(amount, target, source)

func heal(amount: float, source: Character, target: Character) -> void:
	target.heal(amount, source)
	healed.emit(amount, target, source)

func apply_effect(effect: StatusEffect, source: Character, target: Character) -> void:
	target.status_effect_system.apply_effect(effect, source)
