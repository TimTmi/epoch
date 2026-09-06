class_name FireBreath extends Ability


const FLAME: PackedScene = preload("res://combat/hitboxes/flame_cone.tscn")

@export var max_hold: float = 2.0
@export var min_burn_duration: float = 1.0
@export var max_burn_duration: float = 4.0
@export var burn_damage_per_tick: float = 3.0
@export var spawn_distance: float = 6.0

var _flame: FlameCone = null
var _hold_elapsed: float = 0.0


func hold_tick(context: AbilityContext, hold_elapsed: float) -> void:
	_hold_elapsed = hold_elapsed
	# Aim at the live cursor: the intent's targeting only refreshes on press/release.
	var direction: Vector2 = context.user.get_global_mouse_position() - context.user.global_position
	if direction == Vector2.ZERO:
		return
	direction = direction.normalized()

	# Fuel: the breath gutters once the user has blown for max_hold seconds.
	if hold_elapsed >= max_hold:
		_extinguish()
		return

	if _flame == null or not is_instance_valid(_flame):
		_flame = context.world_services.spawn.spawn_hitbox(FLAME, context.user.team)
		_flame.breathed.connect(_on_flame_breathed.bind(context.user))

	var user: Character = context.user
	_flame.refresh()
	_flame.global_position = user.global_position + direction * spawn_distance
	_flame.rotation = direction.angle()

func activate(context: AbilityContext) -> void:
	_extinguish()

func _on_flame_breathed(target: Character, user: Character) -> void:
	if user.is_same_team(target):
		return

	var duration: float = lerpf(min_burn_duration, max_burn_duration, clampf(_hold_elapsed / max_hold, 0.0, 1.0))
	user.apply_status_effect(target, Burn.new(duration, burn_damage_per_tick))

func _extinguish() -> void:
	if _flame != null and is_instance_valid(_flame):
		_flame.extinguish()
	_flame = null
