class_name Hook extends Projectile


signal stuck(body: Node2D)
signal missed

var max_range: float = INF

var _is_stuck: bool = false
var _has_missed: bool = false
var _launch_position: Vector2
var _joint: PinJoint2D
var _stuck_mass_gain: float = 0.0


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func launch(direction: Vector2, force: float, facing_direction: bool = true) -> void:
	_launch_position = global_position
	super.launch(direction, force, facing_direction)

func _physics_process(_delta: float) -> void:
	if _is_stuck or _has_missed:
		return

	if global_position.distance_to(_launch_position) < max_range:
		return

	_has_missed = true
	missed.emit()

func _on_body_entered(body: Node) -> void:
	if _is_stuck:
		return
	
	_is_stuck = true
	stuck.emit(body)
	_stick.call_deferred(body)

func _stick(body: Node) -> void:
	var joint: PinJoint2D = PinJoint2D.new()
	joint.disable_collision = true
	add_child(joint)
	joint.node_a = joint.get_path_to(self)
	joint.node_b = joint.get_path_to(body)
	_stuck_mass_gain = body.mass if body is RigidBody2D else 1306.0
	mass += _stuck_mass_gain
	_joint = joint
	lock_rotation = true

# Releases the hook from the body it stuck to, restoring its pre-stick physics.
func unstick() -> void:
	if _joint:
		_joint.queue_free()
		_joint = null

	mass -= _stuck_mass_gain
	_stuck_mass_gain = 0.0
	lock_rotation = false
