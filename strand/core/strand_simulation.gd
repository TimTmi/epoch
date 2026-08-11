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
	
	var distances: PackedFloat32Array = _build_sample_distances(config.formation, config.target_segment_length)
	
	for i: int in range(distances.size()):
		var position: Vector2 = config.formation.sample(distances[i])
		
		particles.append(StrandParticle.new(position, 1.0))
		
		if i > 0:
			var rest_length: float = particles[i - 1].position.distance_to(position)
			
			constraints.append(
				StrandDistanceConstraint.new(
					particles[i - 1],
					particles[i],
					rest_length
				)
			)

func _build_sample_distances(formation: StrandFormation, target_segment_length: float) -> PackedFloat32Array:
	var total_length: float = formation.get_length()
	var key_distances: PackedFloat32Array = formation.get_key_distances()
	
	var boundaries: PackedFloat32Array = PackedFloat32Array([0.0])
	for kd: float in key_distances:
		if kd > 0.0 and kd < total_length:
			boundaries.append(kd)
	boundaries.append(total_length)
	boundaries.sort()
	
	var distances: PackedFloat32Array = PackedFloat32Array([0.0])
	
	for i: int in boundaries.size() - 1:
		var a: float = boundaries[i]
		var b: float = boundaries[i + 1]
		var section_length: float = b - a
		
		if section_length <= 0.0:
			continue
		
		var subsegment_count: int = max(1, roundi(section_length / target_segment_length))
		var subsegment_length: float = section_length / subsegment_count
		
		for j: int in range(1, subsegment_count + 1):
			distances.append(a + subsegment_length * j)
	
	return distances

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
