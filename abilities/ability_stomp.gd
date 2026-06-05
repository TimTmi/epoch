class_name Stomp extends Ability


const SHOCKWAVE = preload("uid://bgtgir2b55nv4")
const STUN_EFFECT = preload("uid://dc5fedov07j4c")

@export var damage: int = 10
@export var radius: int = 32
@export var duration: float = 0.5
@export var knockback_force: int = 300
@export var stun_duration: float = 1


func activate(context: AbilityContext) -> void:
	var caster: AbilityCaster = context.caster
	
	var shockwave: Shockwave = caster.spawn_hitbox(SHOCKWAVE)
	shockwave.body_entered.connect(_on_body_entered.bind(caster))
	caster.lock_input()
	await shockwave.finished
	caster.unlock_input()

func _on_body_entered(body: Node, caster: AbilityCaster):
	if not body is Character or caster.is_same_team(body):
		return
	
	var target: Character = body
	var caster_global_position: Vector2 = caster.get_global_position()
	var direction = (target.global_position - caster_global_position).normalized()
	var stun_effect = STUN_EFFECT.instantiate()
	
	caster.deal_damage(damage, target)
	caster.push(target, direction * (knockback_force ** 2) / caster_global_position.distance_squared_to(target.global_position))
	stun_effect.wait_time = stun_duration
	caster.apply_effect(target, stun_effect)
