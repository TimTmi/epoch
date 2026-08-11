class_name StrandConfig extends Resource


@export var formation: StrandFormation
@export var target_segment_length: float
@export var iterations: int
@export var gravity: Vector2


func _init(_formation: StrandFormation = StraightFormation.new(), _target_segment_length: float = 1.0, _iterations: int = 1, _gravity: Vector2 = Vector2.ZERO) -> void:
	formation = _formation
	target_segment_length = _target_segment_length
	iterations = _iterations
	gravity = _gravity
