class_name Wall extends StaticBody2D


const FADE_OUT: float = 0.4
const INNER_INSET: float = 1.0

@export var thickness: float = 6.0

var _is_finished: bool = false
var _remaining_lifetime: float = 0.0

@onready var _shape: CollisionShape2D = $CollisionShape2D
@onready var _body: Polygon2D = $Body
@onready var _core: Polygon2D = $Body/Core
@onready var _dust: GPUParticles2D = $Dust


func _ready() -> void:
	_shape.shape = _shape.shape.duplicate()
	# Duplicate shared scene sub-resources so runtime size changes stay instance-local.
	_dust.process_material = _dust.process_material.duplicate()
	_dust.emitting = true

func set_length(length: float) -> void:
	var half_thickness: float = thickness * 0.5
	var half_length: float = length * 0.5
	_shape.shape.size = Vector2(thickness, length)
	_body.polygon = _rectangle(half_thickness, half_length)
	_core.polygon = _rectangle(half_thickness - INNER_INSET, half_length - INNER_INSET)
	_dust.process_material.emission_box_extents = Vector3(half_thickness, half_length, 0)

# Stops growing and starts the lifetime countdown after which the wall crumbles away.
func finish(lifetime: float) -> void:
	_is_finished = true
	_remaining_lifetime = lifetime
	_dust.emitting = false

func _physics_process(delta: float) -> void:
	if not _is_finished:
		return

	_remaining_lifetime -= delta
	if _remaining_lifetime <= 0.0:
		_expire()

func _expire() -> void:
	set_physics_process(false)
	collision_layer = 0
	var tween: Tween = create_tween()
	tween.tween_property(_body, "modulate:a", 0.0, FADE_OUT)
	tween.tween_callback(queue_free)

func _rectangle(half_width: float, half_height: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-half_width, -half_height),
		Vector2(half_width, -half_height),
		Vector2(half_width, half_height),
		Vector2(-half_width, half_height),
	])
