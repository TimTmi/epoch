class_name FloatingText extends Node2D


@onready var label: Label = $Label


func display(text: String, config: FloatingTextConfig) -> void:
	label.text = text
	modulate = config.color
	label.position += config.offset
	
	var angle_offset: float = randf_range(-config.spread * 0.5, config.spread * 0.5)
	var direction: Vector2 = config.direction.rotated(angle_offset)
	
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position", direction * config.distance, config.duration)
	tween.tween_property(self, "modulate:a", 0, config.duration)
	tween.chain().tween_callback(queue_free)
