extends SceneTree


func _initialize() -> void:
	_run()

func _run() -> void:
	var world: World = load("res://world/world.tscn").instantiate()
	root.add_child(world)
	await process_frame

	var wizard: Character = null
	for child: Node in world.characters_container.get_children():
		if child is Character and child.team == &"team_2":
			wizard = child
	_check(wizard != null, "wizard spawned")

	var slot: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.PRIMARY
	var instance: AbilityInstance = wizard.abilities.slot_ability_instances[slot]
	var intent: AbilityIntent = AbilityIntent.from_target_direction(Vector2.RIGHT)
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "press should start hold")

	for i: int in 40:
		await physics_frame
	_check(instance.hold_elapsed > 0.5, "hold should accumulate")

	var previews: Array[Node] = world.projectiles_container.get_children().filter(func(child: Node) -> bool: return child is Bolt)
	_check(previews.size() == 1, "exactly one charging bolt spawned")
	if not previews.is_empty():
		var preview: Bolt = previews[0]
		_check(preview.collision_layer == 0, "charging bolt should have collision disabled")
		_check(preview._core.scale.x > 1.5, "charging bolt should grow with charge")

	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.RELEASE), "release should fire")
	await physics_frame

	var launched: Array[Node] = world.projectiles_container.get_children().filter(func(child: Node) -> bool: return child is Bolt)
	_check(launched.size() == 1, "released bolt should be adopted, not duplicated")
	if not launched.is_empty():
		var bolt: Bolt = launched[0]
		_check(bolt.linear_velocity.length() > 0.0, "released bolt should fly")
		_check(bolt.collision_layer != 0, "released bolt should have collision restored")
		for i: int in 10:
			await physics_frame
		_check(bolt._core.scale.x > 1.5, "launched bolt should keep its charged size")

	for i: int in 60:
		await physics_frame
	var bolts: Array[Node] = world.projectiles_container.get_children().filter(func(child: Node) -> bool: return child is Bolt)
	var explosions: Array[Node] = world.projectiles_container.get_children().filter(func(child: Node) -> bool: return child is BoltExplosion)
	_check(bolts.is_empty(), "bolt should be freed after impact")
	_check(explosions.is_empty(), "explosion should appear after impact and free itself")
	print("SMOKE OK")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
