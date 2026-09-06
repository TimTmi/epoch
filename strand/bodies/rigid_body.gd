class_name RigidStrandBody extends StrandBody


var body: RigidBody2D

var _correction: Vector2 = Vector2.ZERO


func _init(_body: RigidBody2D) -> void:
	body = _body

func get_position() -> Vector2:
	return body.position

func get_inverse_mass() -> float:
	return 1.0 / body.mass

func move(delta: Vector2) -> void:
	body.position += delta
	_correction += delta

func commit_motion(delta_time: float) -> void:
	# Teleporting a rigid body never enters its velocity state, so joints and
	# friction cannot act on the correction. Set the velocity to the frame's
	# displacement rate instead — adding would compound across frames while the
	# reel-in corrects every frame, launching the body.
	body.linear_velocity = _correction / delta_time
	_correction = Vector2.ZERO

func discard_motion() -> void:
	_correction = Vector2.ZERO
