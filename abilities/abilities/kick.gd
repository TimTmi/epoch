class_name Kick extends Ability


const KICK = preload("uid://dyflk7p2dlcdc")

@export var distance: int = 0
@export var duration: float = 0.2
@export var dash_distance: float = 400
@export var knockback_force: float = 400
@export var stun_duration: float = 1
@export var damage: int = 15


func activate(context: AbilityContext) -> void:
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return
	var user: Character = context.user
	
	var kick: CircleStrike = user.spawner.spawn_local_hitbox(KICK)
	
	kick.set_radius(6)
	user.input.lock()
	user.push(user, direction * dash_distance)
	
	var tween = kick.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(kick, "position", direction * distance, duration).as_relative()
	tween.tween_callback(kick.queue_free)
	
	kick.body_entered.connect(_on_body_entered.bind(user))
	
	await tween.finished
	user.input.unlock()

func _on_body_entered(body: Node, user: Character):
	if not body is Character or user.is_same_team(body):
		return
	
	var target: Character = body
	var direction: Vector2 = (target.global_position - user.get_global_position()).normalized()
	
	user.deal_damage(target, damage)
	user.push(target, direction * knockback_force)
	
	var stun: StatusEffect = Stun.new(stun_duration)
	user.apply_status_effect(target, stun)
