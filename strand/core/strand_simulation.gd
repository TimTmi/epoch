class_name StrandSimulation


var config: StrandConfig
var particles: Array[StrandParticle]
var points: PackedVector2Array
var constraints: Array[StrandConstraint]
var solver: StrandSolver


func _init(_config: StrandConfig, _solver: StrandSolver) -> void:
	config = _config
	particles = []
	constraints = []
	solver = _solver
	
	var segment_length: float = config.segment_length
	
	for i: int in range(config.segment_count + 1):
		var distance: float = i * segment_length
		var position: Vector2 = config.formation.sample(distance)
		
		particles.append(StrandParticle.new(position, 1.0))
		
		if i > 0:
			var rest_length: float = particles.get(i - 1).position.distance_to(position)
			
			constraints.append(
				StrandDistanceConstraint.new(
					particles[i - 1],
					particles[i],
					rest_length
				)
			)

func simulate(delta: float) -> void:
	solver.simulate(self, delta)

func get_points() -> PackedVector2Array:
	points.resize(particles.size())
	
	for i: int in particles.size():
		var particle: StrandParticle = particles.get(i)
		var position: Vector2 = particle.position
		points.set(i, position)
	
	return points

func get_particle(index: int) -> StrandParticle:
	return particles.get(index)

func get_start() -> StrandParticle:
	return particles.front()

func get_end() -> StrandParticle:
	return particles.back()

func pin_start() -> void:
	var particle: StrandParticle = get_start()
	if particle:
		particle.set_mass(INF)

func pin_end() -> void:
	var particle: StrandParticle = get_end()
	if particle:
		particle.set_mass(INF)
