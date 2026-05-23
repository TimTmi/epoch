extends Move


const AFTERIMAGE = preload("res://stuff/afterimage.tscn")

@export var duration: float = 10
@export var damage_on_self: float = 50


func _use(_input: Vector2) -> void:
	var tween: Tween = create_tween()
	var afterimage = AFTERIMAGE.instantiate()
	var damage_interval: float = duration / damage_on_self
	var take_damage_function: ComponentFunction = user.get_node("TakeDamage")
	var take_damage_override_function = func(_value: float):
		return 1
	user.add_child(afterimage)
	take_damage_function.add_handler(take_damage_override_function)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in (damage_on_self):
		tween.tween_callback(user.take_damage.bind(1, user))
		tween.tween_interval(damage_interval)
	
	#tween.tween_callback(take_damage_function.handlers.erase.bind(take_damage_override_function))
	tween.tween_callback(take_damage_function.remove_handler.bind(take_damage_override_function))
	tween.tween_callback(afterimage.queue_free)
	tween.tween_callback(end)
