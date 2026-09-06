class_name Strand extends Node2D


signal resize_finished

@export var config: StrandConfig
@export var solver: StrandSolver

var _simulation: StrandSimulation
var _points: PackedVector2Array


func _init(_config: StrandConfig = StrandConfig.new(), _solver: StrandSolver = VerletStrandSolver.new()) -> void:
	config = _config
	solver = _solver
	_simulation = StrandSimulation.new(config, solver)
	_simulation.resize_finished.connect(resize_finished.emit)

func _draw() -> void:
	draw_polyline(_points, config.color, config.width, config.antialiased)

func _physics_process(delta: float) -> void:
	_simulate(delta)
	_render(_simulation.get_points())

func attach_start(body: StrandBody) -> void:
	_simulation.attach_start(body)

func attach_end(body: StrandBody) -> void:
	_simulation.attach_end(body)

func resize_to_length(target_length: float, speed: float) -> void:
	_simulation.resize_to_length(target_length, speed)

func _simulate(delta: float) -> void:
	_simulation.simulate(delta)

func _render(points: PackedVector2Array) -> void:
	_points = points
	queue_redraw()
