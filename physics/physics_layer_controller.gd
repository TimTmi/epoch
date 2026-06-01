class_name PhysicsLayerController extends Resource
 

var layers: Dictionary[StringName, int] = {}
var next_available_layer: int = 0


func has_layer(layer: StringName) -> bool:
	return layers.has(layer)

func get_layer_size() -> int:
	return PhysicsSublayer.Type.size()

func get_layer_offset(layer: StringName) -> int:
	if layers.has(layer):
		return layers.get(layer)
	
	push_warning("Unknown layer: %s" % layer)
	return -1

func get_bit_index(layer: StringName, sublayer: PhysicsSublayer.Type) -> int:
	if not has_layer(layer):
		return -1
	
	return get_layer_offset(layer) + sublayer

func get_full_layer_bitmask() -> int:
	return (1 << get_layer_size()) - 1

func get_layer_bitmask(layer: StringName) -> int:
	if not has_layer(layer):
		return -1
	
	return get_full_layer_bitmask() << get_layer_offset(layer)

func get_sublayer_bitmask(sublayers: Array[PhysicsSublayer.Type]) -> int:
	var bitmask: int = 0
	for sublayer: PhysicsSublayer.Type in sublayers:
		bitmask |= 1 << sublayer
	return bitmask

func get_bitmask(layer: StringName, sublayers: Array[PhysicsSublayer.Type]) -> int:
	if not has_layer(layer):
		return -1
	
	var sublayer_bitmask: int = get_sublayer_bitmask(sublayers)
	return sublayer_bitmask << get_layer_offset(layer)

func add_layer(layer: StringName) -> bool:
	if has_layer(layer):
		push_warning("Layer already exists: %s" % layer)
		return false
	
	var layer_size: int = get_layer_size()	
	
	if layer_size <= 0:
		push_warning("No sublayers configured.")
		return false
	
	if next_available_layer + layer_size > 32:
		push_warning("No free physics layers left.")
		return false
	
	layers.set(layer, next_available_layer)
	next_available_layer += layer_size
	
	return true

func remove_layer(layer_name: StringName) -> bool:
	return layers.erase(layer_name)
