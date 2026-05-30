class_name LayerController extends Resource


@export var available_sublayers: PackedStringArray

var layers: Dictionary[StringName, int] = {}
var next_available_layer: int = 0


func get_layer_size() -> int:
	return available_sublayers.size()

func get_layer_bitmask(layer_name: StringName, target_sublayer_names: PackedStringArray = [], inverted: bool = false) -> int:
	if not layers.has(layer_name):
		push_warning("Unknown layer: %s" % layer_name)
		return 0
	
	var sublayers: int = 0
	
	if target_sublayer_names.is_empty():
		sublayers = (1 << get_layer_size()) - 1
	else:
		for sublayer_name: String in target_sublayer_names:
			var sublayer_index: int = available_sublayers.find(sublayer_name)
			if sublayer_index == -1:
				push_warning("Unknown sublayer: %s" % sublayer_name)
				continue
			sublayers |= 1 << sublayer_index
	
	var bitmask: int = sublayers << layers.get(layer_name)
	return (1 << 32) - 1 - bitmask if inverted else bitmask

func add_layer(layer: StringName) -> bool:
	if next_available_layer + get_layer_size() > 32:
		return false
	
	layers.set(layer, next_available_layer)
	next_available_layer += get_layer_size()
	
	return true

func remove_layer(layer_name: StringName) -> bool:
	return layers.erase(layer_name)
