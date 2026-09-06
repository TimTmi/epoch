class_name FlameCone extends Hitbox


signal breathed(target: Character)


@export var range: float = 64.0
@export var arc_degrees: float = 45.0
@export var burn_interval: float = 0.25
# Physics frames without refresh() before the flame gutters out: guards against
# an interrupted hold (stun, death) leaving a permanent flame.
@export var stale_frame_limit: int = 12

var _frames_since_refresh: int = 0
var _time_until_breath: float = 0.0

@onready var _collision: CollisionPolygon2D = $Collision


func _ready() -> void:
	_collision.polygon = _cone_polygon()

func _physics_process(delta: float) -> void:
	_frames_since_refresh += 1
	if _frames_since_refresh > stale_frame_limit:
		queue_free()
		return

	_time_until_breath -= delta
	if _time_until_breath > 0.0:
		return

	_time_until_breath = burn_interval
	for body: Node2D in get_overlapping_bodies():
		if body is Character and _has_clear_line(body):
			breathed.emit(body)

# Marks the flame as driven: the ability calls this every frame it keeps blowing.
func refresh() -> void:
	_frames_since_refresh = 0

# Fire is blocked by walls: the breath dies against the first static body in the way.
func _has_clear_line(target: Character) -> bool:
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D.create(global_position, target.global_position, collision_mask, [target.get_rid()])
	var hit: Dictionary = space.intersect_ray(query)
	return hit.is_empty() or not hit.collider is StaticBody2D

func _cone_polygon() -> PackedVector2Array:
	var points: PackedVector2Array = [Vector2.ZERO]
	var ray_count: int = 8
	for i: int in ray_count + 1:
		var angle: float = deg_to_rad(lerpf(-arc_degrees, arc_degrees, float(i) / ray_count) * 0.5)
		points.append(Vector2(cos(angle), sin(angle)) * range)
	return points
