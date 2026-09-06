class_name Burn extends StatusEffect


const DAMAGE_INTERVAL: float = 0.5

# Damage lands in DAMAGE_INTERVAL chunks instead of every tick: health changes
# surface as floating text, so per-frame damage would flood the presentation.
var damage_per_tick: float
var _time_until_damage: Dictionary[StatusEffectInstance, float] = {}


func _init(duration: float, damage_per_tick: float) -> void:
	super(duration)
	self.damage_per_tick = damage_per_tick


func get_name() -> StringName:
	return "burn"


func apply(instance: StatusEffectInstance) -> void:
	_time_until_damage[instance] = DAMAGE_INTERVAL
	instance.removed.connect(func(_reason: StatusEffectRemovalReason.Type): _time_until_damage.erase(instance))


func tick(delta: float, instance: StatusEffectInstance) -> void:
	_time_until_damage[instance] -= delta
	if _time_until_damage[instance] > 0.0:
		return

	_time_until_damage[instance] += DAMAGE_INTERVAL
	instance.source.deal_damage(instance.owner, damage_per_tick)
