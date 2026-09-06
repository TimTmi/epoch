class_name AIInput extends InputProvider


var navigation_agent: NavigationAgent2D
var danger_sensor: DangerSensor

# Seconds between first sensing a threat and starting to dodge.
var reaction_time: float = 0.0

var wander_target: Vector2
var _reaction_timer: float = 0.0
var _tracked_threat: Projectile


func _init(character: Character) -> void:
	super(character)
	navigation_agent = character.get_node("NavigationAgent")
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	danger_sensor = DangerSensor.new(character)

func move_to(movement_target: Vector2) -> void:
	navigation_agent.set_target_position(movement_target)
	if navigation_agent.is_navigation_finished():
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = character.global_position.direction_to(next_path_position) * character.speed.current
	navigation_agent.set_velocity(new_velocity)

# Returns the incoming projectile once the reaction time has elapsed, null otherwise.
func sense_threat(delta: float) -> Projectile:
	var threat: Projectile = danger_sensor.sense_incoming()
	if threat == null:
		_tracked_threat = null
		return null
	if threat != _tracked_threat:
		_tracked_threat = threat
		_reaction_timer = reaction_time
	_reaction_timer = maxf(_reaction_timer - delta, 0.0)
	if _reaction_timer > 0.0:
		return null
	return threat

func dodge(threat: Projectile) -> void:
	character.move(_dodge_direction(threat))

func wander() -> void:
	if navigation_agent.is_navigation_finished():
		wander_target = random_point()
	move_to(wander_target)

func random_point() -> Vector2:
	return NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), 1, false)

# Sidestep across the projectile's path and step back away from it.
func _dodge_direction(threat: Projectile) -> Vector2:
	var to_character: Vector2 = character.global_position - threat.global_position
	var heading: Vector2 = threat.linear_velocity.normalized()
	var side: float = signf(heading.cross(to_character))
	if side == 0.0:
		side = 1.0
	var away_from_path: Vector2 = Vector2(-heading.y, heading.x) * side
	return (away_from_path + to_character.normalized() * 0.5).normalized()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	character.move(safe_velocity)
