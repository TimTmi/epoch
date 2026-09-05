class_name Hook extends Projectile


var _is_stuck: bool = false


signal stuck(body: Node2D)


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

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
	mass += body.mass if body is RigidBody2D else 1306.0
	lock_rotation = true
