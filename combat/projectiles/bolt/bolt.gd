class_name Bolt extends Projectile


signal hit(body: Node2D)

const EXPLOSION: PackedScene = preload("res://combat/projectiles/bolt/bolt_explosion.tscn")

@export var max_lifetime: float = 4.0
@export var min_scale: float = 0.8
@export var max_scale: float = 4.0

const CORE_COLORS_UNCHARGED: Array[Color] = [Color(1, 1, 1, 1), Color(0.75, 0.9, 1, 0.8), Color(0.5, 0.75, 1, 0)]
const CORE_COLORS_CHARGED: Array[Color] = [Color(1, 0.9, 1, 1), Color(1, 0.6, 0.95, 0.8), Color(0.85, 0.3, 0.9, 0)]
const TRAIL_COLORS_UNCHARGED: Array[Color] = [Color(0.55, 0.35, 0.95, 0.85), Color(0.3, 0.2, 0.7, 0)]
const TRAIL_COLORS_CHARGED: Array[Color] = [Color(0.95, 0.3, 0.8, 0.85), Color(0.55, 0.15, 0.6, 0)]

var _has_hit: bool = false
var _remaining_lifetime: float
var _charge_user: Node2D = null
var _charge_collision_layer: int = 0
var _charge_collision_mask: int = 0
var _core_gradient: Gradient
var _trail_gradient: Gradient
var _base_radius: float = 0.0
var _size_factor: float = 1.0

@onready var _core: GPUParticles2D = $Core
@onready var _trail: GPUParticles2D = $Trail
@onready var _shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	_remaining_lifetime = max_lifetime
	_shape.shape = _shape.shape.duplicate()
	_base_radius = _shape.shape.radius
	_own_particle_resources()
	_core_gradient = _core.process_material.color_ramp.gradient
	_trail_gradient = _trail.process_material.color_ramp.gradient
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if _charge_user != null:
		if not is_instance_valid(_charge_user):
			queue_free()
		return

	_remaining_lifetime -= delta
	if _remaining_lifetime <= 0.0:
		queue_free()

# Disables physics and freezes the bolt in front of the user while it charges up.
func begin_charge(user: Node2D) -> void:
	_charge_user = user
	_charge_collision_layer = collision_layer
	_charge_collision_mask = collision_mask
	collision_layer = 0
	collision_mask = 0

func end_charge() -> void:
	_charge_user = null
	collision_layer = _charge_collision_layer
	collision_mask = _charge_collision_mask

func set_charge(power: float) -> void:
	# Scale the emitters and collision shape, never the RigidBody2D root:
	# the physics server resets node scale on awake bodies.
	var size: float = lerpf(min_scale, max_scale, power)
	_size_factor = size
	_core.scale = Vector2.ONE * size
	_trail.scale = Vector2.ONE * size
	_shape.shape.radius = _base_radius * size
	_core_gradient.colors = _lerp_colors(CORE_COLORS_UNCHARGED, CORE_COLORS_CHARGED, power)
	_trail_gradient.colors = _lerp_colors(TRAIL_COLORS_UNCHARGED, TRAIL_COLORS_CHARGED, power)

func _lerp_colors(from: Array[Color], to: Array[Color], power: float) -> PackedColorArray:
	var colors: PackedColorArray = PackedColorArray()
	for i: int in from.size():
		colors.append(from[i].lerp(to[i], power))
	return colors

# Duplicates shared scene sub-resources so runtime color changes stay instance-local.
func _own_particle_resources() -> void:
	for particles: GPUParticles2D in [_core, _trail]:
		var material: ParticleProcessMaterial = particles.process_material.duplicate()
		var texture: GradientTexture1D = material.color_ramp.duplicate()
		texture.gradient = texture.gradient.duplicate()
		material.color_ramp = texture
		particles.process_material = material

func _on_body_entered(body: Node2D) -> void:
	if _has_hit:
		return
	_has_hit = true
	_explode()
	hit.emit(body)
	queue_free()

func _explode() -> void:
	var explosion: BoltExplosion = EXPLOSION.instantiate()
	explosion.size_factor = _size_factor
	explosion.colors = _core_gradient.colors
	get_parent().add_child(explosion)
	explosion.global_position = global_position
