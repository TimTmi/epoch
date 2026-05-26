class_name Stomp extends Ability


const SHOCKWAVE = preload("uid://bgtgir2b55nv4")
const STUN_EFFECT = preload("uid://dc5fedov07j4c")

@export var damage: int = 10
@export var radius: int = 32
@export var time: float = 0.5
@export var knockback_force: int = 300
@export var stun_duration: float = 1


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	
	var shockwave: Shockwave = SHOCKWAVE.instantiate()
	var tween: Tween = user.create_tween()
	shockwave.body_entered.connect(_on_body_entered.bind(user))
	user.set_input(false)
	user.add_child(shockwave)
	tween.tween_interval(time)
	tween.tween_callback(user.set_input.bind(true))
	
	await tween.finished

func _on_body_entered(body, user: Character):
	if not body is Character or body.team == user.team:
		return
	
	user.deal_damage(damage, body)
	var direction = (body.position - user.position).normalized()
	body.push(direction * (knockback_force ** 2) / user.position.distance_squared_to(body.position))
	var stun_effect = STUN_EFFECT.instantiate()
	stun_effect.wait_time = stun_duration
	body.apply_effect(stun_effect)
