extends RigidBody2D
class_name Character


const DAMAGE_TEXT = preload("uid://b3vndm3ppg4d3")

@onready var controller: InputController = $InputController
@onready var health: Stat = $Health
@onready var attack_percent: Stat = $AttackPercent
@onready var attack_flat: Stat = $AttackFlat
@onready var defense_percent: Stat = $DefensePercent
@onready var defense_flat: Stat = $DefenseFlat

@export var init_speed: float = 1000
@onready var speed: float = init_speed

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
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "characters", "_character_added", self)
	ready()

func ready():
	pass

func initialize(world_context: WorldContext, config: CharacterConfig, team: StringName, physics_profile: PhysicsProfile) -> void:
	self.world_context = world_context
	self.team = team
	self.physics_profile = physics_profile
	
	config_physics(physics_profile)
	
	apply_config(config)

func config_physics(physics_profile: PhysicsProfile) -> void:
	self.collision_layer = physics_profile.character_layer
	self.collision_mask = physics_profile.character_mask

func apply_config(config: CharacterConfig) -> void:
	var character_stats: CharacterStats = config.stats
	
	#health.current = character_stats.health
	#health.maximum = character_stats.health
	#...
	
	ability_system.setup_abilities(config.slot_abilities, config.passive_abilities)

func get_effective_delta(delta: float) -> float:
	return delta * time_scale

func lock_input() -> void:
	input_locks += 1
	set_process_unhandled_input(true)

func unlock_input() -> void:
	input_locks -= 1
	
	if input_locks < 0:
		push_warning("Input lock count below 0")
		input_locks = 0
	
	set_process_unhandled_input(input_locks == 0)

func try_activate_ability(ability: Ability, intent: AbilityIntent) -> void:
	ability_system.try_activate_ability(ability, intent, self)

func try_activate_slot(slot: AbilitySystem.CommandSlot, intent: AbilityIntent) -> void:
	ability_system.try_activate_slot(slot, intent, self)

func push(force: Vector2):
	apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	direction = direction.normalized() * speed * time_scale
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

func set_health(value: float) -> void:
	$SetHealth.function.call(value, self)

func deal_damage(amount: float, target: Character) -> void:
	$DealDamage.function.call(amount, self, target, world_context)

func take_damage(amount: float, attacker: Character) -> void:
	$TakeDamage.function.call(amount, attacker, self)

func heal(amount: float, healer: Character = self) -> void:
	$Heal.function.call(amount, healer, self)

func apply_effect(effect: StatusEffect, target: Character) -> void:
	world_context.combat.apply_effect(effect, self, target)

func _physics_process(delta: float) -> void:
	ability_system.tick(delta)
	status_effect_system.tick(delta)

func _on_health_changed(old_value: int, new_value: int):
	#var damage_text = DAMAGE_TEXT.instantiate()
	#damage_text.text = str(old_value - new_value)
	#damage_text.position = position - damage_text.size / 2
	#world_context.world.add_child(damage_text)
	if new_value == 0:
		dead.emit()

func _on_damage_dealt(_amount: float, _character: Character):
	pass

func _on_damage_taken(_amount: float, _character: Character):
	pass

func _on_healed(_amount: float):
	pass

func _on_dead():
	queue_free()

func _on_attack_percent_changed(_old_stat, new_stat):
	$DealDamage.multiplier = 1 + new_stat * 0.01

func _on_attack_flat_changed(_old_stat, new_stat):
	$DealDamage.flat_modifier = new_stat

func _on_defense_percent_changed(_old_stat, new_stat):
	$TakeDamage.multiplier = 1 - new_stat * 0.01

func _on_defense_flat_changed(_old_stat, new_stat):
	$TakeDamage.flat_modifier = new_stat
