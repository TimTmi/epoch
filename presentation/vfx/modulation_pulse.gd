class_name ModulationPulse extends RefCounted


const DEFAULT_DURATION: float = 0.2


# Flashes a canvas item's modulation to [color] and fades back to what it was.
static func flash(target: CanvasItem, color: Color, duration: float = DEFAULT_DURATION) -> void:
	var original: Color = target.modulate
	target.modulate = color
	var tween: Tween = target.create_tween()
	tween.tween_property(target, "modulate", original, duration)
