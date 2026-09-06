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
	_check(wizard.input.provider is WizardAI, "world wizard uses WizardAI")

	# Two characters sharing one config must not share stateful abilities.
	var config: CharacterConfig = world.character_registry.get_character(&"wizard")
	var second: Character = world.spawn_service.spawn_character(config, &"team_1", Vector2(300, 0))
	_check(second != null, "second wizard spawned")
	wizard.input.lock()
	second.input.lock()

	var slot: AbilitySystem.CommandSlot = AbilitySystem.CommandSlot.PRIMARY
	var own_ability: Ability = wizard.abilities.slot_ability_instances[slot].ability
	var other_ability: Ability = second.abilities.slot_ability_instances[slot].ability
	_check(own_ability != other_ability, "each character owns its ability copy")

	# Both charge: two independent charging bolts, each next to its own wizard.
	var intent: AbilityIntent = AbilityIntent.from_target_position(Vector2.ZERO)
	_check(wizard.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "first press starts hold")
	_check(second.abilities.try_activate_slot(slot, intent, AbilitySystem.InputPhase.PRESS), "second press starts hold")
	for i: int in 4:
		await physics_frame

	var charging: Array[Node] = world.projectiles_container.get_children().filter(
		func(child: Node) -> bool: return child is Bolt and child.collision_layer == 0)
	_check(charging.size() == 2, "each wizard charges its own bolt, got %d" % charging.size())
	for bolt: Bolt in charging:
		var near_wizard: bool = bolt.global_position.distance_to(wizard.global_position) < 64.0 \
			or bolt.global_position.distance_to(second.global_position) < 64.0
		_check(near_wizard, "charging bolt sits at its own wizard")

	print("SMOKE OK")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("SMOKE FAIL: " + message)
	quit(1)
