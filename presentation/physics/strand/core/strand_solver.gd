class_name StrandSolver extends Resource


func simulate(simulation: StrandSimulation, delta: float) -> void:
	integrate(simulation, delta)
	for _i: int in simulation.iterations:
		solve_constraints(simulation)

func integrate(simulation: StrandSimulation, delta: float) -> void:
	pass

func solve_constraints(simulation: StrandSimulation) -> void:
	for constraint: StrandConstraint in simulation.constraints:
		constraint.solve()
