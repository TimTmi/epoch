class_name StrandSimulation


var config: StrandConfig
var particles: Array[StrandParticle]
var points: PackedVector2Array
var constraints: Array[StrandConstraint]
var solver: StrandSolver

var _resize_target_length: float = -1.0  # negative means no active resize
var _resize_speed: float = 0.0


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
	_apply_resize(delta)
	solver.simulate(self, delta)

func resize_to_length(target_length: float, speed: float) -> void:
	if speed <= 0.0:
		push_error("strand resize speed must be larger than 0")
		return

	_resize_target_length = target_length
	_resize_speed = speed

func get_rest_length() -> float:
	var total_length: float = 0.0
	for constraint: StrandConstraint in constraints:
		if constraint is StrandDistanceConstraint:
			total_length += constraint.distance
	return total_length

func get_length() -> float:
	var total_length: float = 0.0
	for constraint: StrandConstraint in constraints:
		if constraint is StrandDistanceConstraint:
			total_length += constraint.a.get_position().distance_to(constraint.b.get_position())
	return total_length

func _apply_resize(delta: float) -> void:
	if _resize_target_length < 0.0:
		return

	var current_length: float = get_length()
	if is_zero_approx(current_length):
		_resize_target_length = -1.0
		return

	var new_length: float = move_toward(current_length, _resize_target_length, _resize_speed * delta)
	var new_rest_length: float = get_rest_length() * new_length / current_length
	if is_equal_approx(new_length, _resize_target_length) or is_equal_approx(new_rest_length, _resize_target_length):
		_resize_target_length = -1.0

	var factor: float = new_length / current_length
	for constraint: StrandConstraint in constraints:
		if constraint is StrandDistanceConstraint:
			constraint.distance *= factor

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
