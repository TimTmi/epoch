class_name CircleStrike extends Hitbox


@onready var collision: CollisionShape2D = $Collision


func set_radius(radius: float = 2):
	$Collision.shape.radius = radius

func _on_timeout():
	queue_free()
