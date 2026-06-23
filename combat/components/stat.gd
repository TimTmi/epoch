extends Component
class_name Stat


@export var minimum: float = 0
@export var maximum: float = 100
@export var value: float = 100

var initial: float = 100:
	set(value):
		initial = value
		current = initial
var current: float = initial:
	set(value):
		var new = clamp(value, minimum, maximum)
		if current != new:
			stat_changed.emit(current, new)
		current = new


signal stat_changed(old_stat: float, new_stat: float)


func _ready():
	set.call_deferred("initial", value)
