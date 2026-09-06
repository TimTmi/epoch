class_name ChainTrap extends Ability


const HOOK: PackedScene = preload("res://combat/projectiles/hook/hook.tscn")

const HOOK_COUNT: int = 6
const WALL_SEARCH_RANGE: float = 512.0
const WALL_CLEARANCE: float = 8.0

@export var throw_force: float = 600.0
@export var pull_speed: float = 320.0
@export var hold_duration: float = 3.0


func activate(context: AbilityContext) -> void:
	if context.targeting.target_position == Vector2.INF:
		push_warning("ChainTrap requires a target position")
		return

	var user: Character = context.user
	var spawn: SpawnService = context.world_services.spawn
	var wall_mask: int = _get_wall_mask(context)
	var base_angle: float = randf() * TAU

	for index: int in HOOK_COUNT:
		var direction: Vector2 = Vector2.from_angle(base_angle + index * TAU / HOOK_COUNT)
		var wall_hit: Dictionary = _find_wall(context, context.targeting.target_position, direction, wall_mask)
		if wall_hit.is_empty():
			continue

		var wall_position: Vector2 = wall_hit["position"]
		_launch_hook(user, spawn, wall_position, context.targeting.target_position)

func _get_wall_mask(context: AbilityContext) -> int:
	var resolver: PhysicsMaskResolver = context.world_services.world.mask_resolver
	return resolver.get_layer(&"environment", PhysicsSublayer.Type.WALL)

func _find_wall(context: AbilityContext, origin: Vector2, direction: Vector2, mask: int) -> Dictionary:
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(origin, origin + direction * WALL_SEARCH_RANGE, mask)
	return context.user.get_world_2d().direct_space_state.intersect_ray(query)

func _launch_hook(user: Character, spawn: SpawnService, wall_position: Vector2, target_position: Vector2) -> void:
	var to_target: Vector2 = (target_position - wall_position).normalized()
	var spawn_position: Vector2 = wall_position + to_target * WALL_CLEARANCE
	var distance: float = spawn_position.distance_to(target_position)

	var hook: Hook = spawn.spawn_projectile(HOOK, user.team, spawn_position)
	var formation: ZigZagFormation = ZigZagFormation.new(spawn_position, to_target, distance, 16, 8)
	var strand: Strand = spawn.spawn_strand(StrandConfig.new(formation, 4, 20))
	strand.attach_start(AnchorStrandBody.new(spawn_position))
	strand.attach_end(RigidStrandBody.new(hook))

	hook.max_range = distance
	hook.stuck.connect(_on_hook_stuck.bind(strand, hook))
	hook.missed.connect(_on_hook_missed.bind(strand, hook))
	hook.launch(to_target, throw_force)

func _on_hook_stuck(_body: Node2D, strand: Strand, hook: Hook) -> void:
	hook.get_tree().create_timer(hold_duration).timeout.connect(_on_hold_finished.bind(strand, hook))

func _on_hook_missed(strand: Strand, hook: Hook) -> void:
	_retract(strand, hook)

func _on_hold_finished(strand: Strand, hook: Hook) -> void:
	if not is_instance_valid(hook) or not is_instance_valid(strand):
		return

	hook.unstick()
	_retract(strand, hook)

func _retract(strand: Strand, hook: Hook) -> void:
	strand.resize_to_length(13.0, pull_speed)
	strand.resize_finished.connect(_on_retract_finished.bind(strand, hook), CONNECT_ONE_SHOT)

func _on_retract_finished(strand: Strand, hook: Hook) -> void:
	strand.queue_free()
	hook.queue_free()
