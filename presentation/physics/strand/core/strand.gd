class_name Strand extends Node2D


@export var config: StrandConfig
@export var solver: StrandSolver

var _simulation: StrandSimulation
var _points: PackedVector2Array


func _init() -> void:
	_simulation = StrandSimulation.new(config, solver)

func _draw() -> void:
	draw_polyline(_points, config.color, config.width, config.antialiased)

func _physics_process(delta: float) -> void:
	_simulate(delta)
	_render(_simulation.get_points())

func attach_start(body: StrandBody) -> void:
	_simulation.constraints.append(StrandDistanceConstraint.new(_simulation.get_start(), body, 0.0))

func attach_end(body: StrandBody) -> void:
	_simulation.constraints.append(StrandDistanceConstraint.new(_simulation.get_end(), body, 0.0))

func _simulate(delta: float) -> void:
	_simulation.simulate(delta)

func _render(points: PackedVector2Array) -> void:
	_points = points
	queue_redraw()
