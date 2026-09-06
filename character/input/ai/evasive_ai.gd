class_name EvasiveAI extends AIInput


var danger_sensor: DangerSensor
var wander_target: Vector2


func _init(character: Character) -> void:
	super(character)
	danger_sensor = DangerSensor.new(character)

func tick(_delta: float) -> void:
	var threat: Projectile = danger_sensor.sense_incoming()
	if threat != null:
		character.move(_dodge_direction(threat))
		return
	_wander()

# Sidestep across the projectile's path and step back away from it.
func _dodge_direction(threat: Projectile) -> Vector2:
	var to_character: Vector2 = character.global_position - threat.global_position
	var heading: Vector2 = threat.linear_velocity.normalized()
	var side: float = signf(heading.cross(to_character))
	if side == 0.0:
		side = 1.0
	var away_from_path: Vector2 = Vector2(-heading.y, heading.x) * side
	return (away_from_path + to_character.normalized() * 0.5).normalized()

func _wander() -> void:
	if navigation_agent.is_navigation_finished():
		wander_target = _random_point()
	move_to(wander_target)

func _random_point() -> Vector2:
	return NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), 1, false)
