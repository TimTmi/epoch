extends Timer
class_name Ability


@export var icon: Texture = preload("uid://bo7j37st0tbcc")

var user: Character

var on_cooldown: bool = false


signal started
signal ended
signal connected


func _init():
	one_shot = true

func _ready():
	user = get_parent().get_parent()

func to_local(position: Vector2) -> Vector2:
	return position - user.position

func to_direction(position: Vector2) -> Vector2:
	return to_local(position).normalized()

func to_angle(position: Vector2) -> float:
	return user.get_angle_to(position)

func use(input: Vector2) -> void:
	if on_cooldown:
		return
	on_cooldown = true
	_use(input)
	started.emit()

func _use(_input: Vector2) -> void:
	start()

func end():
	ended.emit()
	start()

func _on_timeout():
	on_cooldown = false
