extends SceneTree


var _activations: int = 0


func _initialize() -> void:
	_run()

func _run() -> void:
	var world: World = load("res://world/world.tscn").instantiate()
	root.add_child(world)
	await process_frame

	var quickfist: Character = null
	for child: Node in world.characters_container.get_children():
		if child is Character and child.team == &"team_1":
			quickfist = child
	_check(quickfist != null, "quickfist spawned")
	_check(quickfist.input.provider is QuickfistAI, "world quickfist uses QuickfistAI")

	# Facing the wizard, an aggressive quickfist should keep swinging.
	for instance: AbilityInstance in quickfist.abilities.slot_ability_instances.values():
		instance.started.connect(_on_ability_started)
	for i: int in 180:
		await physics_frame
	_check(_activations > 0, "quickfist activated abilities while engaging, got %d" % _activations)

	print("SMOKE OK")
	quit(0)

func _on_ability_started() -> void:
	_activations += 1

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
