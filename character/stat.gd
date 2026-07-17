class_name Stat


var minimum: float = 0
var maximum: float = 100
var current: float:
	set(value):
		var new = clamp(value, minimum, maximum)
		if current != new:
			stat_changed.emit(current, new)
		current = new


signal stat_changed(old_stat: float, new_stat: float)


func _init(config: StatConfig) -> void:
	self.minimum = config.minimum
	self.maximum = config.maximum
	self.current = config.current
