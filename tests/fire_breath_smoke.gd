extends SceneTree


const WALL: PackedScene = preload("res://combat/obstacles/wall.tscn")


func _initialize() -> void:
	_run()

func _run() -> void:
	var world: World = load("res://world/world.tscn").instantiate()
	root.add_child(world)
	await process_frame

	var wizard: Character = _find_character(world, &"team_2")
	_check(wizard != null, "wizard spawned")
	var enemy: Character = _find_character_not_on_team(world, &"team_2")
	_check(enemy != null, "enemy spawned")

	var slot: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.UTILITY
	var instance: AbilityInstance = wizard.abilities.slot_ability_instances.get(slot)
	_check(instance != null, "fire breath wired on UTILITY slot")

	var intent: AbilityIntent = AbilityIntent.from_target_direction(Vector2.RIGHT)
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "press should start hold")

	for i: int in 5:
		await physics_frame

	var flames: Array[Node] = world.hitboxes_container.get_children().filter(func(child: Node) -> bool: return child is FlameCone)
	_check(flames.size() == 1, "exactly one flame while holding")
	if flames.is_empty():
		return
	var flame: FlameCone = flames[0]
	_check(flame.collision_layer != 0, "flame should be on a hitbox layer")
	_check(flame._collision.polygon.size() > 2, "flame should build its cone shape")

	# The breath follows the live cursor; in headless the cursor sits at a fixed
	# world point, so park the enemy where the flame is actually blowing.
	var aim: Vector2 = Vector2.from_angle(flame.rotation)
	enemy.input.lock()
	enemy.global_position = wizard.global_position + aim * 32.0
	enemy.linear_velocity = Vector2.ZERO

	for i: int in 60:
		await physics_frame
		if enemy.health.current < enemy.health.maximum:
			break
	_check(enemy.health.current < enemy.health.maximum, "burning enemy should lose health over time")
	_check(enemy.status_effects.has_status_effect(&"burn"), "enemy should carry the burn status effect")

	# A wall between wizard and enemy must block the breath.
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.RELEASE), "release should stop holding")
	await physics_frame
	_check(is_instance_valid(flame) and not flame.monitoring, "flame should stop burning on release")

	# Let the burn from the first blow expire so the wall check measures cleanly.
	# Repeated breath applications stack burn duration, so this can take a while.
	for i: int in 900:
		if not enemy.status_effects.has_status_effect(&"burn"):
			break
		await physics_frame
	_check(not enemy.status_effects.has_status_effect(&"burn"), "burn should expire")
	for i: int in 40:
		await physics_frame

	var health_before_blocked: float = enemy.health.current
	var wall: Wall = wizard.world_services.spawn.spawn_obstacle(WALL, wizard.global_position + aim * 16.0, aim.angle())
	wall.set_length(64.0)
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "press should start hold again")

	for i: int in 90:
		await physics_frame
	_check(is_instance_valid(enemy) and enemy.health.current >= health_before_blocked, "wall should block the breath from reaching the enemy")

	# An interrupted hold (stun or death mid-blow) must not leave a permanent flame.
	instance.reset_chain()
	for i: int in 20:
		await physics_frame
	_check(is_instance_valid(flame) and not flame.monitoring, "unrefreshed flame should gutter out")

	print("SMOKE OK")
	quit(0)

func _find_character(world: World, team: StringName) -> Character:
	for child: Node in world.characters_container.get_children():
		if child is Character and child.team == team:
			return child
	return null

func _find_character_not_on_team(world: World, team: StringName) -> Character:
	for child: Node in world.characters_container.get_children():
		if child is Character and child.team != team:
			return child
	return null

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
