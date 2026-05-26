class_name CircleStrike extends Area2D


func set_radius(radius: float = 2):
	$Collision.shape.radius = radius

func _on_timeout():
	queue_free()
