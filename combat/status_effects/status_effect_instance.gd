class_name StatusEffectInstance


var effect: StatusEffect
var source: Character
var owner: Character
var duration_remaining: float = 0.0:
	set(value):
		duration_remaining = maxf(0.0, value)


signal applied()
signal removed(reason: StatusEffectRemovalReason.Type)


func _init(effect: StatusEffect, source: Character, owner: Character) -> void:
	self.effect = effect
	self.source = source
	self.owner = owner

func apply() -> void:
	effect.apply(self)
	applied.emit()
	duration_remaining = effect.duration

func tick(delta: float) -> void:
	duration_remaining -= delta
	effect.tick(delta, self)
	
	if duration_remaining <= 0:
		remove(StatusEffectRemovalReason.Type.EXPIRED)

func remove(reason: StatusEffectRemovalReason.Type) -> void:
	effect.remove(reason, self)
	removed.emit(reason)
