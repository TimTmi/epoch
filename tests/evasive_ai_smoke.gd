extends SceneTree


func _initialize() -> void:
	_run()

func _run() -> void:
	var world: World = load("res://world/world.tscn").instantiate()
	root.add_child(world)
	await process_frame

	var config: CharacterConfig = world.character_registry.get_character(&"evasive_dummy")
	_check(config != null, "evasive_dummy registered")
	var dummy: Character = world.spawn_service.spawn_character(config, &"team_1", Vector2.ZERO)
	_check(dummy != null, "evasive dummy spawned")

	var ai: EvasiveAI = dummy.input.provider as EvasiveAI
	_check(ai != null, "evasive dummy uses EvasiveAI")

	# Path following: walk to a point across the arena via the navmesh.
	ai.move_to(Vector2(-160, 0))
	var arrived: bool = false
	for i: int in 400:
		await physics_frame
		if dummy.global_position.distance_to(Vector2(-160, 0)) < 24.0:
			arrived = true
			break
	_check(arrived, "dummy walks to target around obstacles via navmesh")

	# Danger dodge: reset to the x axis and pin the wander target on it.
	dummy.global_position = Vector2.ZERO
	dummy.linear_velocity = Vector2.ZERO
	ai.move_to(Vector2(160, 0))
	var threat: Projectile = Projectile.new()
	threat.gravity_scale = 0.0
	threat.collision_layer = 0
	threat.collision_mask = 0
	var shape_node: CollisionShape2D = CollisionShape2D.new()
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = 3.0
	shape_node.shape = shape
	threat.add_child(shape_node)
	threat.position = Vector2(-80, 0)
	world.projectiles_container.add_child(threat)
	threat.linear_velocity = Vector2(120.0, 0.0)
	await physics_frame
	await physics_frame

	_check(ai.danger_sensor.sense_incoming() != null, "sensor detects incoming projectile")

	for i: int in 60:
		await physics_frame
	_check(absf(dummy.global_position.y) > 4.0, "dummy sidesteps out of the projectile path")

	# Once the projectile is gone, nothing counts as incoming danger.
	threat.queue_free()
	await physics_frame
	await physics_frame
	_check(ai.danger_sensor.sense_incoming() == null, "no danger reported without projectiles")

	print("SMOKE OK")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
