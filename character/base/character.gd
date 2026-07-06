extends RigidBody2D
class_name Character


var team: StringName
var physics_profile: PhysicsProfile

var world_context: WorldContext

var stats: CharacterStats
var input: CharacterInput
var spawner: CharacterSpawner
var ability_system: AbilitySystem
var status_effect_system: StatusEffectSystem = StatusEffectSystem.new(self)

var positions : PackedVector2Array = []
var time_scale: float = 1

var input_locks: int = 0


func _ready():
	ready()

func ready():
	pass

func initialize(world_context: WorldContext, config: CharacterConfig, team: StringName, physics_profile: PhysicsProfile) -> void:
	self.world_context = world_context
	self.team = team
	self.physics_profile = physics_profile
	
	stats = CharacterStats.new(config.stats)
	spawner = CharacterSpawner.new(self, world_context)
	
	setup_input(config.input_script)
	config_physics()
	
	ability_system = AbilitySystem.new(config.slot_abilities, config.passive_abilities)

func setup_input(input_script: GDScript) -> void:
	if input_script == null:
		input_script = CharacterInput
		push_error("[character %s (%s)] input script is not set" %[name, get_instance_id()])
	
	var object: Object = input_script.new(self)
	if not object is CharacterInput:
		object = CharacterInput.new(self)
		push_error("[character %s (%s)] input script is not of type CharacterInput" %[name, get_instance_id()])
	
	input = object

func config_physics() -> void:
	collision_layer = physics_profile.character_layer
	collision_mask = physics_profile.character_mask

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

func _unhandled_input(event: InputEvent) -> void:
	if input_locks == 0:
		input.handle_input(event)

#func try_activate_ability(ability: Ability, intent: AbilityIntent) -> void:
	#ability_system.try_activate_ability(ability, intent, self)

func try_activate_slot(slot: AbilitySystem.CommandSlot, intent: AbilityIntent) -> void:
	if input_locks <= 0:
		ability_system.try_activate_slot(slot, intent, self, world_context.combat)

func is_same_team(character: Character) -> bool:
	return team == character.team

func push(target: Character, force: Vector2):
	target.apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	if input_locks > 0:
		return
	
	direction = direction.normalized() * stats.speed.current * time_scale
	apply_central_force(direction)

func _physics_process(delta: float) -> void:
	ability_system.tick(delta)
	status_effect_system.tick(delta)
	
	if input_locks == 0:
		input.tick(delta)
