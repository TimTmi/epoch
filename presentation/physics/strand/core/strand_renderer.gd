@abstract class_name StrandRenderer extends Node2D


var config: StrandRendererConfig


func _init(_config: StrandRendererConfig) -> void:
	config = _config

@abstract func render(points: PackedVector2Array) -> void
