class_name DangerSensor extends RefCounted

# How far the sensor sees incoming projectiles, and how close a projectile's
# path must pass to count as a threat. Larger radius = earlier reaction.
var detection_radius: float = 96.0
var path_tolerance: float = 10.0


var character: Character


func _init(character: Character) -> void:
	self.character = character

# Returns the nearest projectile on a collision course with the character, or null.
func sense_incoming() -> Projectile:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = detection_radius
	query.shape = shape
	query.transform = Transform2D(0.0, character.global_position)
	query.exclude.append(character.get_rid())

	var space_state: PhysicsDirectSpaceState2D = character.get_world_2d().direct_space_state
	var nearest: Projectile = null
	var nearest_distance: float = INF
	for hit: Dictionary in space_state.intersect_shape(query, 16):
		var projectile: Projectile = hit.collider as Projectile
		if projectile == null or not is_incoming(projectile):
			continue
		var distance: float = character.global_position.distance_to(projectile.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = projectile
	return nearest

func is_incoming(projectile: Projectile) -> bool:
	if projectile.linear_velocity.is_zero_approx():
		return false
	var to_character: Vector2 = character.global_position - projectile.global_position
	if to_character.dot(projectile.linear_velocity) <= 0.0:
		return false
	# Distance between the character and the projectile's line of travel.
	var path_distance: float = to_character.cross(projectile.linear_velocity) / projectile.linear_velocity.length()
	return absf(path_distance) <= path_tolerance
