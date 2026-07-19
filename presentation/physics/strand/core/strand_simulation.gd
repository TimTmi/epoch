class_name StrandSimulation


var config: StrandConfig
var particles: Array[StrandParticle]
var constraints: Array[StrandConstraint]
var solver: StrandSolver


func _init(_config: StrandConfig, _solver: StrandSolver) -> void:
	config = _config
	particles = []
	constraints = []
	solver = _solver
	
	var delta: Vector2 = config.end_position - config.start_position
	var rest_length: float = delta.length() / config.segment_count
	
	particles.append(StrandParticle.new(config.start_position, 1))
	
	for i: int in range(1, config.segment_count + 1):
		var t: float = float(i) / config.segment_count
		var position: Vector2 = config.start_position + delta * t
		particles.append(StrandParticle.new(position, 1))
		
		constraints.append(StrandDistanceConstraint.new(particles.get(i), particles.get(i - 1), rest_length))

func simulate(delta: float) -> void:
	solver.simulate(self, delta)

func get_particle(index: int) -> StrandParticle:
	return particles.get(index)

func pin_start() -> void:
	var particle: StrandParticle = particles.front()
	if particle:
		particle.inverse_mass = 0.0

func pin_end() -> void:
	var particle: StrandParticle = particles.back()
	if particle:
		particle.inverse_mass = 0.0
