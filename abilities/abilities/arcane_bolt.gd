class_name ArcaneBolt extends Ability


const BOLT: PackedScene = preload("res://combat/projectiles/bolt/bolt.tscn")
const CHARGE_DISTANCE: float = 10.0

@export var max_hold: float = 1.5
@export var min_damage: float = 5.0
@export var max_damage: float = 25.0
@export var min_launch_force: float = 350.0
@export var max_launch_force: float = 750.0
@export var min_knockback: float = 100.0
@export var max_knockback: float = 350.0

var _charging_bolt: Bolt = null


func hold_tick(context: AbilityContext, hold_elapsed: float) -> void:
	var user: Character = context.user
	var direction: Vector2 = (user.get_global_mouse_position() - user.global_position)
	if direction == Vector2.ZERO:
		return
	direction = direction.normalized()

	if _charging_bolt == null or not is_instance_valid(_charging_bolt):
		_charging_bolt = context.world_services.spawn.spawn_projectile(BOLT, user.team, user.position)
		_charging_bolt.begin_charge(user)

	_charging_bolt.set_charge(clampf(hold_elapsed / max_hold, 0.0, 1.0))
	_charging_bolt.global_position = user.global_position + direction * CHARGE_DISTANCE

func activate(context: AbilityContext) -> void:
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		_cancel_charge()
		return

	var user: Character = context.user
	var power: float = clampf(context.hold_duration / max_hold, 0.0, 1.0)
	var bolt: Bolt = _take_charge_bolt()
	if bolt == null:
		bolt = context.world_services.spawn.spawn_projectile(BOLT, user.team, user.position)

	bolt.set_charge(power)
	bolt.hit.connect(_on_bolt_hit.bind(user, power))
	bolt.launch(direction, lerpf(min_launch_force, max_launch_force, power))

func _take_charge_bolt() -> Bolt:
	if _charging_bolt == null or not is_instance_valid(_charging_bolt):
		return null
	var bolt: Bolt = _charging_bolt
	_charging_bolt = null
	bolt.end_charge()
	return bolt

func _cancel_charge() -> void:
	if _charging_bolt != null and is_instance_valid(_charging_bolt):
		_charging_bolt.queue_free()
	_charging_bolt = null

func _on_bolt_hit(body: Node, user: Character, power: float) -> void:
	if not body is Character or user.is_same_team(body):
		return

	var target: Character = body
	var direction: Vector2 = (target.global_position - user.get_global_position()).normalized()

	user.deal_damage(target, lerpf(min_damage, max_damage, power))
	user.push(target, direction * lerpf(min_knockback, max_knockback, power))
