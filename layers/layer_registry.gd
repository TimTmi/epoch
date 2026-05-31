class_name LayerRegistry extends Resource


@export var layers: PackedStringArray


func get_layer_count() -> int:
	return layers.size()

func get_layer_index(layer_name: StringName) -> int:
	return layers.find(layer_name)
