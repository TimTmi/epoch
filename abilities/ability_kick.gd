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
	var user: Character = context.user
	var direction: Vector2 = context.get_target_direction()
	if direction == Vector2.INF:
		return
	
	var kick: CircleStrike = KICK.instantiate()
	
	kick.set_radius(6)
	user.set_input(false)
	user.add_child(kick)
	user.apply_central_impulse(direction * dash_distance)
	
	var tween = user.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(kick, "position", direction * distance, duration).as_relative()
	tween.tween_callback(user.set_input.bind(true))
	tween.tween_callback(kick.queue_free)
	
	kick.body_entered.connect(_on_body_entered.bind(user))
	
	await tween.finished

func _on_body_entered(body, user: Character):
	if not body is Character or body.team == user.team:
		return
	user.deal_damage(damage, body)
	var direction = (body.position - user.position).normalized()
	body.push(direction * knockback_force)
	var stun_effect = STUN_EFFECT.instantiate()
	stun_effect.wait_time = stun_duration
	body.apply_effect(stun_effect)
