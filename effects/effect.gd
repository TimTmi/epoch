extends Timer
class_name Effect


@onready var character: Character = get_parent().get_parent()

@export var effect_name: String

@export_enum("Add", "Replace", "Ignore") var stack_type: int


func _on_timeout():
	queue_free()
