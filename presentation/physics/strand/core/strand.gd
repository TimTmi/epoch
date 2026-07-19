class_name Strand extends Node2D


var simulation: StrandSimulation
var renderer: StrandRenderer


func _init(_config: StrandConfig, _solver: StrandSolver, _renderer: StrandRenderer) -> void:
	simulation = StrandSimulation.new(_config, _solver)
	renderer = _renderer
	
	add_child(renderer)

func _physics_process(delta: float) -> void:
	simulate(delta)

func simulate(delta: float) -> void:
	simulation.simulate(delta)
	renderer.render(simulation)
