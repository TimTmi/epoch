class_name Punch extends Ability


const PUNCH = preload("uid://dyflk7p2dlcdc")
const STUN_EFFECT = preload("uid://dc5fedov07j4c")

@export var distance: int = 10
@export var duration: float = 0.2
@export var dash_distance: float = 200
@export var knockback_force: float = 200
@export var stun_duration: float = 0.2
@export var damage: int = 5

var combo = 0
var clockwise = randi_range(0, 1) * 2 - 1


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	var direction: Vector2 = context.get_target_direction()
	if direction == Vector2.INF:
		return
	
	var punch: CircleStrike = PUNCH.instantiate()
	var punch_collision = punch.get_node("Collision")
	var angle = PI/2 * -clockwise
	user.set_input(false)
	punch_collision.position.x = distance
	punch.look_at(direction)
	punch.rotate(angle)
	
	#punch.position = (direction * distance).rotated(angle)
	#joint.position = user.position
	
	user.add_child(punch)
	#user.add_child(joint)
	
	#joint.node_a = user.get_path()
	#joint.node_b = punch.get_path()
	
	user.apply_central_impulse(direction * dash_distance)
	#punch.apply_central_impulse(direction * dash_distance * 3)
	#punch.apply_central_impulse((direction * dash_distance).rotated(PI / 2 * clockwise))
	
	var tween = punch.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#print(punch.get_children())
	tween.tween_property(punch, "rotation", PI * clockwise, duration).as_relative()
	#tween.tween_interval(duration)
	tween.tween_callback(user.set_input.bind(true))
	#tween.tween_callback(joint.queue_free)
	tween.tween_callback(punch.queue_free)
	
	clockwise = -clockwise
	punch.body_entered.connect(_on_body_entered.bind(user))
	
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
