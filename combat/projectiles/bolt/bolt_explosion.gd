class_name BoltExplosion extends GPUParticles2D


# Mimics the bolt's charged look at impact; colors are handed over by the bolt.
var size_factor: float = 1.0
var colors: PackedColorArray = PackedColorArray()


func _ready() -> void:
	var material: ParticleProcessMaterial = process_material.duplicate()
	var texture: GradientTexture1D = material.color_ramp.duplicate()
	texture.gradient = texture.gradient.duplicate()
	material.color_ramp = texture
	process_material = material

	if not colors.is_empty():
		texture.gradient.colors = colors
	scale = Vector2.ONE * size_factor
	emitting = true
	finished.connect(queue_free)
