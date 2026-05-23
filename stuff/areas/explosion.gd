extends Area2D


@onready var collision = $Collision
@onready var particles = $Particles
@onready var timer = $Timer

@export var radius: int = 32
@export var time: float = 0.5
@export_range(0, 10) var damping: float = 3

@onready var velocity: float = radius / time * (2 ** damping)
@onready var internal_damping: float = int(damping > 0) * (velocity ** 2) * 0.5 / radius


func _ready():
	particles.initial_velocity_min = velocity
	particles.initial_velocity_max = velocity
	
	particles.damping_min = internal_damping / 1.1
	particles.damping_max = internal_damping * 1.1
	
	particles.amount = radius * 2
	particles.lifetime = time
	particles.emitting = true
	
	timer.start(time)

func _physics_process(delta):
	collision.shape.radius += velocity * delta
	velocity -= internal_damping * delta
	set_physics_process(velocity > 0)

func _on_timer_timeout():
	queue_free()
