class_name Wall extends StaticBody2D


const FADE_OUT: float = 0.4
const CHUNK_LENGTH: float = 12.0
const INNER_INSET: float = 1.0
const RISE_TIME: float = 0.25
const RISE_STAGGER: float = 0.05
const RISE_DISTANCE: float = 6.0
const BASE_COLOR: Color = Color(0.36, 0.26, 0.17, 1)
const CORE_COLOR: Color = Color(0.52, 0.39, 0.25, 1)

@export var thickness: float = 6.0

var _is_finished: bool = false
var _remaining_lifetime: float = 0.0
var _chunks: Array[Node2D] = []

@onready var _shape: CollisionShape2D = $CollisionShape2D
@onready var _dust: GPUParticles2D = $Dust


func _ready() -> void:
	_shape.shape = _shape.shape.duplicate()
	# Duplicate shared scene sub-resources so runtime size changes stay instance-local.
	_dust.process_material = _dust.process_material.duplicate()
	_dust.emitting = true

func set_length(length: float) -> void:
	var chunk_count: int = maxi(1, ceili(length / CHUNK_LENGTH))
	_shape.shape.size = Vector2(thickness, float(chunk_count) * CHUNK_LENGTH)
	_dust.process_material.emission_box_extents = Vector3(thickness * 0.5, float(chunk_count) * CHUNK_LENGTH * 0.5, 0)
	_layout_chunks(chunk_count)

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
	tween.tween_property(self, "modulate:a", 0.0, FADE_OUT)
	tween.tween_callback(queue_free)

func _layout_chunks(chunk_count: int) -> void:
	while _chunks.size() < chunk_count:
		_add_chunk()
	while _chunks.size() > chunk_count:
		_chunks.pop_back().queue_free()
	for index: int in _chunks.size():
		var center_offset: float = (float(index) - float(_chunks.size() - 1) * 0.5) * CHUNK_LENGTH
		_chunks[index].position = Vector2(0, center_offset)

func _add_chunk() -> void:
	var chunk: Node2D = Node2D.new()
	# Riser separates the spawn animation from the chunk's layout position.
	var riser: Node2D = Node2D.new()
	chunk.add_child(riser)
	riser.add_child(_make_rock_polygon(BASE_COLOR, CHUNK_LENGTH * 0.5))
	riser.add_child(_make_rock_polygon(CORE_COLOR, CHUNK_LENGTH * 0.5 - INNER_INSET))
	add_child(chunk)
	_chunks.append(chunk)
	_play_rise(riser)

func _make_rock_polygon(color: Color, half_length: float) -> Polygon2D:
	var polygon: Polygon2D = Polygon2D.new()
	polygon.color = color * (1.0 + randf_range(-0.08, 0.08))
	polygon.polygon = _rectangle(thickness * 0.5, half_length)
	return polygon

# Chunks heave up out of the ground with a center-out ripple: one eased progress
# value drives the rise offset, scale, and fade so the curve stays in one place.
func _play_rise(riser: Node2D) -> void:
	var index: int = _chunks.size() - 1
	var delay: float = absf(float(index) - float(_chunks.size() - 1) * 0.5) * RISE_STAGGER
	_apply_rise(0.0, riser)
	var tween: Tween = create_tween()
	tween.tween_method(_apply_rise.bind(riser), 0.0, 1.0, RISE_TIME).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# tween_method passes the eased progress first; the riser comes from the bind.
func _apply_rise(progress: float, riser: Node2D) -> void:
	riser.position = Vector2(-RISE_DISTANCE * (1.0 - progress), 0)
	riser.scale = Vector2.ONE * lerpf(0.5, 1.0, progress)
	riser.modulate.a = clampf(progress * 2.0, 0.0, 1.0)

func _rectangle(half_width: float, half_height: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-half_width, -half_height),
		Vector2(half_width, -half_height),
		Vector2(half_width, half_height),
		Vector2(-half_width, half_height),
	])
