class_name LineStrandRenderer extends StrandRenderer


var line: Line2D


func _init(_line: Line2D) -> void:
	line = _line
	add_child(line)

func render(simulation: StrandSimulation) -> void:
	#simulation.
	pass
