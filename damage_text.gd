extends Label
class_name DamageText


@onready var world = get_node("/root/GlobalManager").world

@export var offset: Vector2 = Vector2(0, -8)
@export var spread: float = PI/4
@export var distance: int = 32
@export var duration: float = 0.5
@export var color: Color




func _ready():
	var angle = randf_range(-spread/2, spread/2)
	var tween = create_tween().set_parallel()
	position += offset
	if text.begins_with("-"):
		modulate = Color.LIGHT_GREEN
		text = text.substr(1)
	tween.tween_property(self, "position", Vector2(0,-distance).rotated(angle), duration).as_relative()
	tween.tween_property(self, "modulate:a", 0, duration)
	tween.chain().tween_callback(queue_free)
