class_name WizardAI extends AIInput


# Wizard ability slots, matching wizard_config.tres.
const BOLT_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.PRIMARY
const WALL_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SECONDARY
const DASH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.UTILITY
const BREATH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SPECIAL

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

var _target: Character


func tick(delta: float) -> void:
	if not _update_target():
		wander()
		return
	character.aim_position = _target.global_position

	var threat: Projectile = sense_threat(delta)
	_handle_wall(threat)
	if threat != null:
		_release(BOLT_SLOT)
		_release(BREATH_SLOT)
		dodge(threat)
		return
	_fight()

func _update_target() -> bool:
	_target = _nearest_enemy()
	return _target != null

func _nearest_enemy() -> Character:
	var nearest: Character = null
	var nearest_distance: float = INF
	for node: Node in character.world_services.world.characters_container.get_children():
		var enemy: Character = node as Character
		if enemy == null or character.is_same_team(enemy):
			continue
		var distance: float = character.global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = enemy
	return nearest

func _fight() -> void:
	var distance: float = character.global_position.distance_to(_target.global_position)
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
		if instance.hold_elapsed >= bolt_charge_time:
			_release(BOLT_SLOT)
		return
	if instance.cooldown_remaining <= 0.0:
		character.try_activate_slot(BOLT_SLOT, _aim_intent(), AbilitySystem.InputPhase.PRESS)

func _handle_breath() -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[BREATH_SLOT]
	if instance.is_holding:
		if instance.hold_elapsed >= breath_hold_time:
			_release(BREATH_SLOT)
		return
	if instance.cooldown_remaining <= 0.0:
		character.try_activate_slot(BREATH_SLOT, _aim_intent(), AbilitySystem.InputPhase.PRESS)

# Dash out of grappling range, otherwise back off into the kiting band.
func _keep_range(distance: float) -> void:
	var away: Vector2 = character.global_position.direction_to(_target.global_position) * -1.0
	if distance <= dash_range and character.abilities.slot_ability_instances[DASH_SLOT].cooldown_remaining <= 0.0:
		character.try_activate_slot(DASH_SLOT, AbilityIntent.from_target_direction(away), AbilitySystem.InputPhase.PRESS)
	if distance < retreat_range or distance > engage_range:
		move_to(_target.global_position + away * engage_range)

func _release(slot: AbilitySystem.CommandSlot) -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[slot]
	if instance.is_holding:
		character.try_activate_slot(slot, _aim_intent(), AbilitySystem.InputPhase.RELEASE)

func _aim_intent() -> AbilityIntent:
	return AbilityIntent.from_target_position(_target.global_position)
