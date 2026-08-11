@abstract class_name StrandFormation extends Resource


@abstract func get_length() -> float
@abstract func sample(distance: float) -> Vector2

func get_key_distances() -> PackedFloat32Array:
	return PackedFloat32Array()
