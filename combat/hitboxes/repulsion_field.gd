extends Hitbox


@export var radius: int = 16:
	set(value):
		radius = value
		$Collision.shape.radius = value

var bodies: Array = []


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.get(&"time_scale") == null:
		return
	bodies.append(body)
	#if body is RigidBody2D:
		#prints(body, (body.global_position - global_position) * (300 ** 2) / global_position.distance_squared_to(body.global_position))
		#body.apply_central_force((body.global_position - global_position).normalized() * 2000)
	#if body is RigidBody2D:
		#bodies.append(body)

func _on_body_exited(body):
	bodies.erase(body)
	body.time_scale = 1
	#body.apply_central_force((i.global_position - global_position) * (300 ** 2) / global_position.distance_squared_to(i.global_position))
	#if body is RigidBody2D:
		#bodies.erase(body)

func _physics_process(_delta):
	for i in bodies:
		i.time_scale = global_position.distance_to(i.position) / radius
	#for i in bodies:
		#i.apply_central_force((i.global_position - global_position) * (300 ** 2) / global_position.distance_squared_to(i.global_position))
