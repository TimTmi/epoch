extends RigidBody2D
class_name Character


const DAMAGE_TEXT = preload("uid://b3vndm3ppg4d3")

@onready var input_controller: InputController = $InputController

var health: Stat
var speed: Stat

var ability_system: AbilitySystem = AbilitySystem.new()
var status_effect_system: StatusEffectSystem = StatusEffectSystem.new(self)

var positions : PackedVector2Array = []
var time_scale: float = 1

var input_locks: int = 0

var team: StringName
var physics_profile: PhysicsProfile

var world_context: WorldContext


#signal health_changed(old_value: int, new_value: int)
#signal damage_dealt(amount: float)
#signal damage_taken(amount: float)
#signal healed(amount: float)
signal dead


func _ready():
	add_to_group("characters")
	ready()

func ready():
	pass

func initialize(world_context: WorldContext, config: CharacterConfig, team: StringName, physics_profile: PhysicsProfile) -> void:
	self.world_context = world_context
	self.team = team
	self.physics_profile = physics_profile
	
	config_stats(config.stats)
	config_physics(physics_profile)
	
	ability_system.setup_abilities(config.slot_abilities, config.passive_abilities)

func config_stats(stats: CharacterStats) -> void:
	health = Stat.new(stats.health)
	speed = Stat.new(stats.speed)

func config_physics(physics_profile: PhysicsProfile) -> void:
	self.collision_layer = physics_profile.character_layer
	self.collision_mask = physics_profile.character_mask

func get_effective_delta(delta: float) -> float:
	return delta * time_scale

#---INPUT---

func lock_input() -> void:
	input_locks += 1
	set_process_unhandled_input(true)

func unlock_input() -> void:
	input_locks -= 1
	
	if input_locks < 0:
		push_warning("Input lock count below 0")
		input_locks = 0
	
	set_process_unhandled_input(input_locks == 0)

#func try_activate_ability(ability: Ability, intent: AbilityIntent) -> void:
	#ability_system.try_activate_ability(ability, intent, self)

func try_activate_slot(slot: AbilitySystem.CommandSlot, intent: AbilityIntent) -> void:
	ability_system.try_activate_slot(slot, intent, self, world_context.combat)

func is_same_team(character: Character) -> bool:
	return team == character.team

func push(target: Character, force: Vector2):
	target.apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	direction = direction.normalized() * speed.current * time_scale
	apply_central_force(direction)

func spawn_local_hitbox(scene: PackedScene) -> Hitbox:
	var hitbox: Hitbox = scene.instantiate()
	if hitbox == null:
		return null
	
	hitbox.setup_physics(physics_profile)
	
	add_child(hitbox)
	return hitbox

func spawn_global_hitbox(scene: PackedScene) -> Hitbox:
	return world_context.spawn.spawn_hitbox(scene, team)

func spawn_projectile(scene: PackedScene) -> Projectile:
	var projectile: Projectile = scene.instantiate()
	if projectile == null:
		return null
	
	#TODO: physics setup
	
	add_child(projectile)
	return projectile

func spawn_vfx(scene: PackedScene) -> Node2D:
	var vfx = scene.instantiate()
	
	add_child(vfx)
	return vfx

func _physics_process(delta: float) -> void:
	ability_system.tick(delta)
	status_effect_system.tick(delta)
