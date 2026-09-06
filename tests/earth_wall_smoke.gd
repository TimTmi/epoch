extends SceneTree


const BOLT: PackedScene = preload("res://combat/projectiles/bolt/bolt.tscn")


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

	var slot: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.SECONDARY
	var instance: AbilityInstance = wizard.abilities.slot_ability_instances.get(slot)
	_check(instance != null, "earth wall wired on SECONDARY slot")

	var intent: AbilityIntent = AbilityIntent.from_target_direction(Vector2.RIGHT)
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "press should start hold")

	for i: int in 40:
		await physics_frame

	var walls: Array[Node] = world.obstacles_container.get_children().filter(func(child: Node) -> bool: return child is Wall)
	_check(walls.size() == 1, "exactly one wall raised while holding")
	if walls.is_empty():
		return
	var wall: Wall = walls[0]
	_check(wall.collision_layer != 0, "rising wall should block")
	_check(wall._chunks.size() >= 4, "wall should expand chunk by chunk while held")
	_check(wall._chunks[0].get_child(0).scale.x > 0.9, "chunks should settle after rising out of the ground")
	_check(wall._dust.emitting, "dust particles should show the expansion")

	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.RELEASE), "release should finish the wall")
	await physics_frame
	_check(is_instance_valid(wall) and not wall._dust.emitting, "finished wall should stop expanding")

	var bolt: Bolt = world.spawn_service.spawn_projectile(BOLT, wizard.team, wizard.global_position)
	bolt.launch(Vector2.RIGHT, 300.0)
	for i: int in 90:
		if not is_instance_valid(bolt):
			break
		await physics_frame
	_check(not is_instance_valid(bolt), "bolt should be blocked by the wall")
	_check(is_instance_valid(wall) and wall.collision_layer != 0, "wall should survive the impact")

	print("SMOKE OK")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
