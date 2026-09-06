class_name WizardAI extends AIInput


# Wizard ability slots, matching wizard_config.tres.
const BOLT_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.PRIMARY
const WALL_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SECONDARY
const DASH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.UTILITY
const BREATH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SPECIAL

# How far a single retreat step aims to travel.
const RETREAT_STEP: float = 96.0
# Trying to move but staying below this velocity for STUCK_TIME means the orbit
# is grinding a wall and should flip direction.
const STUCK_SPEED: float = 40.0
const STUCK_TIME: float = 0.5

# Range band the wizard kites within.
var retreat_range: float = 160.0
var engage_range: float = 300.0
# Cast ranges for the close-range answers.
var breath_range: float = 150.0
var dash_range: float = 110.0

# Seconds to hold each channeled cast.
var bolt_charge_time: float = 1.0
var wall_hold_time: float = 0.4
var breath_hold_time: float = 1.5

var _strafe_sign: float = 1.0
var _is_moving: bool = false
var _stuck_time: float = 0.0


func tick(delta: float) -> void:
	if not update_target():
		wander()
		return
	character.aim_position = target.global_position

	var threat: Projectile = sense_threat(delta)
	_handle_wall(threat)
	if threat != null:
		_release(BOLT_SLOT)
		_release(BREATH_SLOT)
		dodge(threat)
	else:
		_fight()
	_update_strafe_direction(delta)

func _fight() -> void:
	var distance: float = character.global_position.distance_to(target.global_position)
	if distance <= breath_range:
		_handle_breath()
	else:
		_handle_bolt()
	_keep_range(distance)

# Wall up while a projectile is incoming; finish the cast once it is not.
func _handle_wall(threat: Projectile) -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[WALL_SLOT]
	if instance.is_holding:
		if instance.hold_elapsed >= wall_hold_time:
			_release(WALL_SLOT)
		return
	if threat != null and instance.cooldown_remaining <= 0.0:
		character.try_activate_slot(WALL_SLOT, AbilityIntent.from_target_position(threat.global_position), AbilitySystem.InputPhase.PRESS)

func _handle_bolt() -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[BOLT_SLOT]
	if instance.is_holding:
		# A wall between wizard and target eats the bolt; stop feeding it.
		if instance.hold_elapsed >= bolt_charge_time or not _has_line_of_sight():
			_release(BOLT_SLOT)
		return
	if instance.cooldown_remaining <= 0.0 and _has_line_of_sight():
		character.try_activate_slot(BOLT_SLOT, _aim_intent(), AbilitySystem.InputPhase.PRESS)

func _handle_breath() -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[BREATH_SLOT]
	if instance.is_holding:
		if instance.hold_elapsed >= breath_hold_time:
			_release(BREATH_SLOT)
		return
	if instance.cooldown_remaining <= 0.0:
		character.try_activate_slot(BREATH_SLOT, _aim_intent(), AbilitySystem.InputPhase.PRESS)

# Circle the target at kiting distance: back off sideways when crowded, close in
# when it strays, sidestep when cover blocks the shot. Circling instead of backing
# off straight keeps the wizard in open space instead of walking into corners.
func _keep_range(distance: float) -> void:
	var toward: Vector2 = character.global_position.direction_to(target.global_position)
	var side: Vector2 = Vector2(-toward.y, toward.x) * _strafe_sign
	if distance <= dash_range and character.abilities.slot_ability_instances[DASH_SLOT].cooldown_remaining <= 0.0:
		character.try_activate_slot(DASH_SLOT, AbilityIntent.from_target_direction(side - toward * 0.7), AbilitySystem.InputPhase.PRESS)
	if distance < retreat_range:
		move_to(_nearest_walkable(character.global_position + (side - toward * 0.7).normalized() * RETREAT_STEP))
		_is_moving = true
	elif distance > engage_range:
		move_to(_nearest_walkable(target.global_position - toward * engage_range))
		_is_moving = true
	elif not _has_line_of_sight():
		move_to(_nearest_walkable(character.global_position + side * RETREAT_STEP))
		_is_moving = true
	else:
		_is_moving = false

# Flip the orbit direction when the wizard tries to move but grinds nearly to a
# standstill, e.g. pushing into a wall along a valid-looking nav path.
func _update_strafe_direction(delta: float) -> void:
	if not _is_moving or character.linear_velocity.length() > STUCK_SPEED:
		_stuck_time = 0.0
		return
	_stuck_time += delta
	if _stuck_time >= STUCK_TIME:
		_stuck_time = 0.0
		_strafe_sign *= -1.0

func _nearest_walkable(point: Vector2) -> Vector2:
	return NavigationServer2D.map_get_closest_point(navigation_agent.get_navigation_map(), point)

# True when nothing on the environment layer stands between wizard and target.
func _has_line_of_sight() -> bool:
	var wall_mask: int = character.world_services.world.mask_resolver.get_layer(&"environment", PhysicsSublayer.Type.WALL)
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(character.global_position, target.global_position, wall_mask)
	return character.get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func _release(slot: AbilitySystem.CommandSlot) -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[slot]
	if instance.is_holding:
		character.try_activate_slot(slot, _aim_intent(), AbilitySystem.InputPhase.RELEASE)

func _aim_intent() -> AbilityIntent:
	return AbilityIntent.from_target_position(target.global_position)
