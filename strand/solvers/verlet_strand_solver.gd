class_name VerletStrandSolver extends StrandSolver


func integrate(simulation: StrandSimulation, delta: float) -> void:
	var delta_squared: float = delta ** 2
	
	for particle: StrandParticle in simulation.particles:
		if is_zero_approx(particle.inverse_mass):
			continue
		
		var velocity: Vector2 = particle.position - particle.previous_position
		var current_position: Vector2 = particle.position
		
		particle.position += velocity + (particle.acceleration + simulation.config.gravity) * delta_squared
		particle.previous_position = current_position
		particle.acceleration = Vector2.ZERO
