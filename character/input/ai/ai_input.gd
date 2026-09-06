class_name AIInput extends InputProvider


var navigation_agent: NavigationAgent2D


func _init(character: Character) -> void:
	super(character)
	navigation_agent = character.get_node("NavigationAgent")
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

func move_to(movement_target: Vector2) -> void:
	navigation_agent.set_target_position(movement_target)
	if navigation_agent.is_navigation_finished():
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = character.global_position.direction_to(next_path_position) * character.speed.current
	navigation_agent.set_velocity(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	character.move(safe_velocity)
