extends RigidBody2D
class_name Character


var team: StringName
var physics_profile: PhysicsProfile

var world_context: WorldContext

var stats: CharacterStats
var input: CharacterInput
var spawner: CharacterSpawner
var abilities: AbilitySystem
var status_effects: StatusEffectSystem

var positions : PackedVector2Array = []
var time_scale: float = 1


func initialize(world_context: WorldContext, config: CharacterConfig, team: StringName, physics_profile: PhysicsProfile) -> void:
	self.world_context = world_context
	self.team = team
	self.physics_profile = physics_profile
	
	config_physics()
	
	stats = CharacterStats.new(config.stats)
	input = CharacterInput.new(self, config.input_script)
	spawner = CharacterSpawner.new(self, world_context)
	abilities = AbilitySystem.new(config.slot_abilities, config.passive_abilities)
	status_effects = StatusEffectSystem.new(self)

func config_physics() -> void:
	collision_layer = physics_profile.character_layer
	collision_mask = physics_profile.character_mask

func get_effective_delta(delta: float) -> float:
	return delta * time_scale

func _unhandled_input(event: InputEvent) -> void:
	input.handle_input(event)

func try_activate_ability(ability: Ability, intent: AbilityIntent) -> void:
	abilities.try_activate_ability(ability, intent, self)

func try_activate_slot(slot: AbilitySystem.CommandSlot, intent: AbilityIntent) -> void:
	abilities.try_activate_slot(slot, intent, self, world_context.combat)

func is_same_team(character: Character) -> bool:
	return team == character.team

func push(target: Character, force: Vector2):
	target.apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	direction = direction.normalized() * stats.speed.current * time_scale
	apply_central_force(direction)

func _physics_process(delta: float) -> void:
	input.tick(delta)
	abilities.tick(delta)
	status_effects.tick(delta)
