class_name Punch extends Ability


const PUNCH = preload("uid://dyflk7p2dlcdc")

@export var distance: int = 10
@export var duration: float = 0.2
@export var dash_distance: float = 200
@export var knockback_force: float = 200
@export var stun_duration: float = 0.2
@export var damage: int = 5

var combo = 0
var clockwise = randi_range(0, 1) * 2 - 1


func activate(context: AbilityContext) -> void:
	var caster: AbilityCaster = context.caster
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return
	
	var punch: CircleStrike = caster.spawn_local_hitbox(PUNCH)
	var angle = PI/2 * -clockwise
	punch.collision.position.x = distance
	punch.rotation = direction.angle()
	punch.rotate(angle)
	
	caster.lock_input()
	caster.impulse(direction * dash_distance)
	
	var tween = punch.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(punch, "rotation", PI * clockwise, duration).as_relative()
	tween.tween_callback(punch.queue_free)
	
	clockwise = -clockwise
	punch.body_entered.connect(_on_body_entered.bind(caster))
	
	await tween.finished
	caster.unlock_input()

func _on_body_entered(body: Node, caster: AbilityCaster):
	if not body is Character or caster.is_same_team(body):
		return
	
	var target: Character = body
	var direction: Vector2 = (target.global_position - caster.get_global_position()).normalized()
	
	caster.deal_damage(damage, target)
	caster.push(target, direction * knockback_force)
	
	var stun: StatusEffect = Stun.new(stun_duration)
	caster.apply_effect(stun, target)
