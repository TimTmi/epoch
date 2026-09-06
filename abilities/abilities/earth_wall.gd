class_name EarthWall extends Ability


const WALL: PackedScene = preload("res://combat/obstacles/wall.tscn")

@export var max_hold: float = 1.0
@export var min_length: float = 32.0
@export var max_length: float = 112.0
@export var cast_distance: float = 12.0
@export var lifetime: float = 8.0

var _wall: Wall = null
var _direction: Vector2 = Vector2.INF


func hold_tick(context: AbilityContext, hold_elapsed: float) -> void:
	var direction: Vector2 = context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return

	if _wall == null or not is_instance_valid(_wall):
		_wall = _spawn_wall(context, direction)

	_wall.set_length(_length_for(hold_elapsed))

func activate(context: AbilityContext) -> void:
	var direction: Vector2 = _direction if _direction != Vector2.INF else context.targeting.get_target_direction()
	if direction == Vector2.INF:
		return

	var wall: Wall = _take_wall()
	if wall == null:
		wall = _spawn_wall(context, direction)

	wall.set_length(_length_for(context.hold_duration))
	wall.finish(lifetime)

func _spawn_wall(context: AbilityContext, direction: Vector2) -> Wall:
	_direction = direction
	var user: Character = context.user
	var position: Vector2 = user.global_position + direction * cast_distance
	return context.world_services.spawn.spawn_obstacle(WALL, position, direction.angle())

func _take_wall() -> Wall:
	if _wall == null or not is_instance_valid(_wall):
		return null
	var wall: Wall = _wall
	_wall = null
	return wall

func _length_for(hold_duration: float) -> float:
	return lerpf(min_length, max_length, clampf(hold_duration / max_hold, 0.0, 1.0))
