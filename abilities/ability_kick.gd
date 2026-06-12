class_name Kick extends Ability


const KICK = preload("uid://dyflk7p2dlcdc")
const STUN_EFFECT = preload("uid://dc5fedov07j4c")

@export var distance: int = 0
@export var duration: float = 0.2
@export var dash_distance: float = 400
@export var knockback_force: float = 400
@export var stun_duration: float = 1
@export var damage: int = 15


func activate(context: AbilityContext) -> void:
	var caster: AbilityCaster = context.caster
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return
	
	var kick: CircleStrike = caster.spawn_local_hitbox(KICK)
	
	kick.set_radius(6)
	caster.lock_input()
	caster.impulse(direction * dash_distance)
	
	var tween = kick.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(kick, "position", direction * distance, duration).as_relative()
	tween.tween_callback(kick.queue_free)
	
	kick.body_entered.connect(_on_body_entered.bind(caster))
	
	await tween.finished
	caster.unlock_input()

func _on_body_entered(body: Node, caster: AbilityCaster):
	if not body is Character or caster.is_same_team(body):
		return
	
	var target: Character = body
	var direction: Vector2 = (target.global_position - caster.get_global_position()).normalized()
	var stun_effect = STUN_EFFECT.instantiate()
	
	caster.deal_damage(damage, target)
	caster.push(target, direction * knockback_force)
	stun_effect.wait_time = stun_duration
	caster.apply_effect(target, stun_effect)
