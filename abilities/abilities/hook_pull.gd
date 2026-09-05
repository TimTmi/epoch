class_name HookPull extends Ability


const HOOK: PackedScene = preload("res://combat/projectiles/hook/hook.tscn")

@export var hook_length: float = 130.0
@export var throw_force: float = 1300.0
@export var pull_speed: float = 1300.0


func activate(context: AbilityContext) -> void:
	var direction: Vector2 = context.targeting.get_target_direction()
	var user: Character = context.user
	var spawn: SpawnService = context.world_services.spawn
	
	var strand_formation: StrandFormation = ZigZagFormation.new(user.position, direction, hook_length, 16, 8)
	var strand_config: StrandConfig = StrandConfig.new(strand_formation, 4, 20)
	
	var hook: Hook = spawn.spawn_projectile(HOOK, user.team, user.position)
	
	var strand: Strand = spawn.spawn_strand(strand_config)
	strand.attach_start(RigidStrandBody.new(user))
	strand.attach_end(RigidStrandBody.new(hook))
	
	hook.stuck.connect(_on_hook_stuck.bind(strand))
	hook.launch(direction, throw_force)

func _on_hook_stuck(body: Node2D, strand: Strand) -> void:
	strand.resize_to_length(13.0, pull_speed)
	#strand.reel_in()
	return
