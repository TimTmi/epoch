extends RigidBody2D
class_name Rigid

var time_scale: float = 1:
	set(value):
		time_scale = value
		time_scale_changed.emit(value)
var collision_exceptions: Array[int] = []

signal time_scale_changed(value: float)

func _init():
	set_collision_layer(pow(2, 32) - 1)
	set_collision_mask(pow(2, 32) - 1)

func add_collision_exception(layer: int):
	collision_exceptions.append(layer)
	set_collision_layer_value(layer, false)
	set_collision_mask_value(layer, false)
