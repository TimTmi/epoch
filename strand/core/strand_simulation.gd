class_name StrandSimulation


signal resize_finished

var config: StrandConfig
var particles: Array[StrandParticle]
var points: PackedVector2Array
var constraints: Array[StrandConstraint]
var bodies: Array[StrandBody]
var solver: StrandSolver

var _resize_target_length: float = -1.0  # negative means no active resize
var _resize_speed: float = 0.0
var _start_body: StrandBody
var _end_body: StrandBody


func _init(_config: StrandConfig, _solver: StrandSolver) -> void:
	config = _config
	particles = []
	constraints = []
	solver = _solver
	
	var distances: PackedFloat32Array = _build_sample_distances(config.formation, config.target_segment_length)
	
	for i: int in range(distances.size()):
		var position: Vector2 = config.formation.sample(distances[i])
		
		particles.append(StrandParticle.new(position, 0.01))
		
		if i > 0:
			var rest_length: float = particles[i - 1].position.distance_to(position)
			
			constraints.append(
				StrandDistanceConstraint.new(
					particles[i - 1],
					particles[i],
					rest_length,
					config.stiffness
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
	var reeled_length: float = _apply_resize(delta)
	if reeled_length > 0.0:
		_reel_bodies(reeled_length)
	solver.simulate(self, delta)
	_update_bodies(delta)

func _update_bodies(delta: float) -> void:
	# While resizing, the strand drives its bodies (reel-in): corrections must
	# become velocity so joints transfer the pull. Otherwise the strand only
	# follows passively — e.g. a thrown hook must keep its launch momentum.
	if _resize_target_length >= 0.0:
		for body: StrandBody in bodies:
			body.commit_motion(delta)
	else:
		for body: StrandBody in bodies:
			body.discard_motion()

func attach_start(body: StrandBody) -> void:
	_start_body = body
	_attach(get_start(), body)

func attach_end(body: StrandBody) -> void:
	_end_body = body
	_attach(get_end(), body)

func _attach(particle: StrandParticle, body: StrandBody) -> void:
	bodies.append(body)
	constraints.append(StrandDistanceConstraint.new(particle, body, 0.0, config.stiffness))

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

# Returns the length reeled in this frame (0.0 when no resize is active).
func _apply_resize(delta: float) -> float:
	if _resize_target_length < 0.0:
		return 0.0

	var current_length: float = _get_span()
	if is_zero_approx(current_length):
		_finish_resize()
		return 0.0

	var new_length: float = move_toward(current_length, _resize_target_length, _resize_speed * delta)
	var new_rest_length: float = get_rest_length() * new_length / current_length
	# The rest-length check is a fallback for jammed bodies the winch cannot move.
	if is_equal_approx(new_length, _resize_target_length) or new_rest_length <= _resize_target_length:
		_finish_resize()

	var factor: float = new_length / current_length
	for constraint: StrandConstraint in constraints:
		if constraint is StrandDistanceConstraint:
			constraint.distance *= factor

	return current_length - new_length

func _get_span() -> float:
	if _start_body and _end_body:
		return _start_body.get_position().distance_to(_end_body.get_position())
	return get_length()

func _reel_bodies(reeled_length: float) -> void:
	# The rope particles are far lighter than the attached bodies, so the solver's
	# mass-weighted corrections fold the rope instead of moving the bodies — the
	# resize rate never reaches them. Drive the bodies directly instead: a winch
	# that moves each end along the strand by its mass-weighted share of the
	# reeled length. Goes through move() so commit_motion turns it into velocity.
	if _start_body == null or _end_body == null:
		return

	var start_position: Vector2 = _start_body.get_position()
	var end_position: Vector2 = _end_body.get_position()
	var span: float = start_position.distance_to(end_position)
	var total: float = minf(reeled_length, span - _resize_target_length)
	if is_zero_approx(span) or total <= 0.0:
		return

	var direction: Vector2 = (end_position - start_position) / span
	var inverse_mass_sum: float = _start_body.get_inverse_mass() + _end_body.get_inverse_mass()
	if is_zero_approx(inverse_mass_sum):
		return

	_start_body.move(direction * total * _start_body.get_inverse_mass() / inverse_mass_sum)
	_end_body.move(-direction * total * _end_body.get_inverse_mass() / inverse_mass_sum)

func _finish_resize() -> void:
	_resize_target_length = -1.0
	_resize_speed = 0.0
	resize_finished.emit()

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
		particle.mass = INF

func pin_end() -> void:
	var particle: StrandParticle = get_end()
	if particle:
		particle.mass = INF
