extends SceneTree


var frames := 0


func _initialize() -> void:
	var setup: Node = load("res://menus/game_setup.tscn").instantiate()
	root.add_child(setup)
	current_scene = setup
	# Pick the second entry for the player, first for the enemy, then start.
	setup.player_list.select(1)
	setup.enemy_list.select(0)
	setup._on_start_pressed()

func _process(_delta: float) -> bool:
	frames += 1
	if frames < 10:
		return false
	var world: Node = current_scene
	print("current_scene: ", world.name)
	for character: Node in world.get_node("Characters").get_children():
		print("spawned: ", character.name, " team=", character.team, " pos=", character.position)
	quit()
	return true
