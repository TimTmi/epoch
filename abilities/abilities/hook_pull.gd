class_name HookPull extends Ability


const HOOK: PackedScene = preload("res://combat/projectiles/hook/hook.tscn")

@export var hook_length: float = 1000.0
@export var throw_force: float = 100.0


func activate(context: AbilityContext) -> void:
	var direction: Vector2 = context.targeting.get_target_direction()
	var user: Character = context.user
	var spawn: SpawnService = context.world_services.spawn
	
	var strand_formation: StrandFormation = SpiralFormation.new(user.position, 0.0, 16.0)
	var strand_config: StrandConfig = StrandConfig.new(strand_formation, 4)
	
	var hook: Hook = spawn.spawn_projectile(HOOK, user.team, user.position)
	
	var strand: Strand = spawn.spawn_strand(strand_config)
	strand.attach_start(RigidStrandBody.new(user))
	strand.attach_end(RigidStrandBody.new(hook))
	
	
	hook.launch(direction, throw_force)
