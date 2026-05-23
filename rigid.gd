extends RigidBody2D


const SPEED = 6000.0
var positions : PackedVector2Array = []
var time_scale = 1


func _physics_process(_delta):
	var velocity = Vector2.ZERO
#	positions.append(position)
	velocity.x = Input.get_axis("a", "d")
	velocity.y = Input.get_axis("w", "s")
	velocity = velocity.normalized() * SPEED * time_scale
	apply_central_force(velocity)
