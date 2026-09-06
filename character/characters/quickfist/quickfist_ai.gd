class_name QuickfistAI extends AIInput


# Quickfist ability slots, matching quickfist_config.tres.
const PUNCH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.PRIMARY
const KICK_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SECONDARY
const DASH_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.UTILITY
const STOMP_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SPECIAL
const RAGE_SLOT: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.ULTIMATE

# Attack reach bands; the closest ready attack wins.
var stomp_range: float = 48.0
var punch_range: float = 80.0
var kick_range: float = 260.0
var dash_range: float = 420.0
# Rage is the opener: trade self-damage for doubled damage once the fight is on.
var rage_range: float = 400.0


func tick(delta: float) -> void:
	if not update_target():
		wander()
		return
	character.aim_position = target.global_position

	var threat: Projectile = sense_threat(delta)
	if threat != null:
		dodge(threat)
		return
	_fight()

# No kiting: close in relentlessly and swing whatever is in reach. Checks are
# independent so a cooldown-blocked closer attack never starves a farther one.
func _fight() -> void:
	var distance: float = character.global_position.distance_to(target.global_position)
	if distance <= rage_range:
		_activate(RAGE_SLOT)
	if distance <= stomp_range:
		_activate(STOMP_SLOT)
	if distance <= punch_range:
		_activate(PUNCH_SLOT)
	if distance <= kick_range and distance > punch_range:
		_activate(KICK_SLOT)
	if distance >= dash_range:
		_activate(DASH_SLOT, AbilityIntent.from_target_direction(character.global_position.direction_to(target.global_position)))
	move_to(target.global_position)

# Press a click-activated ability when it is off cooldown.
func _activate(slot: AbilitySystem.CommandSlot, intent: AbilityIntent = null) -> void:
	var instance: AbilityInstance = character.abilities.slot_ability_instances[slot]
	if instance.cooldown_remaining > 0.0:
		return
	if intent == null:
		intent = AbilityIntent.from_target_position(target.global_position)
	character.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS)
